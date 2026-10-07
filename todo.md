- Noctalia Calendar integration with icloud calendar
- Umbriel Overview in Noctalia Bar
- Correct cursor in xwayland apps
- Set up automated encrypted off-machine backups when a suitable destination
  is available, with retention, integrity checks, failure notifications, and
  a tested restore procedure. Keep backup and LUKS recovery credentials
  accessible without this computer.
- Add automatic Btrfs snapshots for /home with bounded retention and disk
  usage. Decide whether root snapshots are useful alongside Nix generations.
- Check firmware-update support after activating fwupd: run
  `fwupdmgr get-devices` and `fwupdmgr refresh`, then `fwupdmgr get-updates`.
- Document an update workflow that builds the full system before activation
  and tests login, suspend/resume, gaming, and screen sharing after desktop
  stack updates. Preserve a proven working generation through cleanup.
- Decide on the boot security policy: use manual LUKS unlocking or complete
  and test a signed Secure Boot chain (for example with Lanzaboote) before
  relying on TPM auto-unlock against theft of the whole computer.
- Review the kernel override when the 7.2 series reaches end of support and
  move to a supported series compatible with the NVIDIA driver.
