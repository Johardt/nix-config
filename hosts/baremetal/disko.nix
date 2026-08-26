{
  disko.devices.disk.main = {
    type = "disk";
    # Crucial P3 1 TB, serial 2243E67E472C. Keep the destructive target tied
    # to the physical drive rather than its probe-order-dependent kernel name.
    device = "/dev/disk/by-id/nvme-CT1000P3SSD8_2243E67E472C";

    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          size = "1G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        root = {
          size = "100%";

          content = {
            type = "luks";
            name = "cryptroot";
            passwordFile = "/tmp/disko-password";
            settings.allowDiscards = true;

            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L"
                "root"
              ];

              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
