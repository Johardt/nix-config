# Fresh NixOS installation with Disko

These instructions install this repository's `baremetal` output for user
`joel` from a NixOS live environment. Substitute the repository URL and verify
the machine-specific target disk before starting.

> **Warning:** Disko's `destroy,format,mount` mode erases the target disk in
> full. This procedure is for a fresh installation, not an in-place migration.
> Keep backups and disconnect disks that must not be touched.

## 1. Prepare the installer

Boot a recent NixOS installer in UEFI mode and connect it to the network. Check
every disk by path, size, model, and serial number:

```bash
lsblk -d -o PATH,SIZE,MODEL,SERIAL
```

Inspect `disko.nix` and verify that `disko.devices.disk.main.device` identifies
the intended physical disk by model and serial number. The committed
`/dev/disk/by-id/...` path is specific to this machine and must be changed when
installing on different hardware.

Clone the configuration into the live environment:

```bash
nix-shell -p git
git clone <repo-url> /tmp/nixos-config
cd /tmp/nixos-config
```

## 2. Create the LUKS recovery credential

`disko.nix` expects a temporary file containing the initial LUKS passphrase.
Use a strong, unique passphrase and preserve it in a password manager plus an
offline recovery location. The TPM is an additional key slot, not a
replacement for this credential.

```bash
umask 077
read -r -s -p 'LUKS recovery passphrase: ' luks_password
printf '\n'
printf '%s' "$luks_password" > /tmp/disko-password
unset luks_password
```

## 3. Validate and create the disk layout

Build the resolved Disko operation without changing a disk:

```bash
sudo nix --extra-experimental-features 'nix-command flakes' \
  run /tmp/nixos-config#disko -- \
  --dry-run --flake /tmp/nixos-config#baremetal
```

Review the configured device again. When certain that it is disposable,
create the encrypted layout and mount it at `/mnt`:

```bash
sudo nix --extra-experimental-features 'nix-command flakes' \
  run /tmp/nixos-config#disko -- \
  --mode destroy,format,mount --flake /tmp/nixos-config#baremetal
```

Verify the result before installing:

```bash
lsblk -f
findmnt --real --output TARGET,SOURCE,FSTYPE,OPTIONS --submounts /mnt
```

## 4. Generate hardware configuration

Copy the repository to a persistent location on the new root filesystem. This
example uses `/etc/nixos`; it can be moved into the configured user's home
after the first boot.

```bash
sudo mkdir -p /mnt/etc/nixos
sudo cp -a /tmp/nixos-config/. /mnt/etc/nixos/
sudo nixos-generate-config --root /mnt --show-hardware-config \
  | sudo tee /mnt/etc/nixos/hosts/baremetal/hardware-configuration.nix >/dev/null
```

Review the generated module. Confirm that `/`, `/home`, `/nix`, and
`/.snapshots` use the expected Btrfs subvolumes and that it contains a
`boot.initrd.luks.devices.cryptroot` entry for the encrypted root partition:

```nix
boot.initrd.luks.devices."cryptroot" = {
  device = "/dev/disk/by-uuid/<generated-luks-uuid>";
};
```

Keep the generated device UUID, but make sure the attribute name is
`cryptroot`, matching `disko.nix`. The main host configuration owns the
machine-independent unlock policy: it enables the systemd initrd and adds
`tpm2-device=auto`. Do not duplicate that option in the generated hardware
module.

## 5. Install and enroll the TPM

Install the selected flake output:

```bash
sudo nixos-install \
  --extra-experimental-features 'nix-command flakes' \
  --flake /mnt/etc/nixos#baremetal
```

Find the encrypted partition in `lsblk -f`, then enroll the target machine's
TPM. With the adjacent layout, the partition is normally available at
`/dev/disk/by-partlabel/disk-main-root`. The command asks for the LUKS recovery
passphrase and adds a separate TPM slot.

```bash
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  /dev/disk/by-partlabel/disk-main-root
sudo systemd-cryptenroll \
  /dev/disk/by-partlabel/disk-main-root
```

Confirm that the second command lists both `password` and `tpm2` slots. PCR 7
binds unlocking to the firmware's Secure Boot policy. Enabling, disabling, or
changing that policy will require the recovery passphrase once and TPM
re-enrollment. Without Secure Boot, TPM unlocking primarily protects against a
removed drive; it is not strong protection against boot-chain modification on
a stolen complete computer.

Set the normal user's login password before the first boot:

```bash
sudo nixos-enter --root /mnt
passwd joel
exit
sudo shred -u /tmp/disko-password
sudo reboot
```

After booting, place the repository at the path expected by the host
configuration, give it to the configured user, and preserve the generated
hardware module in version control. Subsequent rebuilds can use the host's
normal rebuild command, such as:

```bash
nh os switch
```

## Layout provided here

The adjacent `disko.nix` creates a GPT disk with a 1 GiB unencrypted EFI System
Partition and a LUKS2-encrypted Btrfs filesystem containing:

| Subvolume | Mount point | Purpose |
| --- | --- | --- |
| `@root` | `/` | Operating-system root |
| `@home` | `/home` | Persistent user data |
| `@nix` | `/nix` | Nix store and state |
| `@snapshots` | `/.snapshots` | Filesystem snapshots |

The Btrfs mounts use Zstandard compression and `noatime`. The layout does not
create swap, RAID, or automatic snapshots.

TPM enrollment is necessarily machine-specific and remains a one-time
installation step. If automatic unlocking fails after firmware, TPM, or boot
policy changes, enter the retained LUKS recovery passphrase and re-enroll the
TPM. Never remove the recovery credential merely because TPM unlocking works.
