{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myModules.users;
  types = lib.types;

  matKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"
  ];

  matPasswordHash = "$6$gMQHadaVYwaBrtfO$y8pVFG0p2mT.iDQ5XYdTIG8GaqNDaQFwuH29z4VaJkYwlYGKCkrZClAixfl8IcPL3aqIh80cv7sq6M2nBx9gd1";
in {
  options.myModules.users = {
    enable = lib.mkEnableOption "users";

    mat = lib.mkOption {
      type = types.bool;
      default = true;
    };
    mz = lib.mkOption {
      type = types.bool;
      default = false;
    };
    kelvas = lib.mkOption {
      type = types.bool;
      default = false;
    };
    syam = lib.mkOption {
      type = types.bool;
      default = false;
    };
    cerebre = lib.mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      users.mutableUsers = false;
      users.users.root.hashedPassword = matPasswordHash;
    }

    (lib.mkIf cfg.mat {
      users.groups.mat.gid = 1000;

      users.users.mat = {
        isNormalUser = true;
        group = "mat";
        linger = true;
        uid = 1000;
        shell = pkgs.fish;
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput" "media" "audio" "seat" "kvm" "libvirtd"];
        openssh.authorizedKeys.keys = matKeys;
        hashedPassword = matPasswordHash;
      };
    })

    (lib.mkIf cfg.mz {
      users.users.mz = {
        isNormalUser = true;
        uid = 1001;
        shell = pkgs.zsh;
        initialPassword = "test";
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
        openssh.authorizedKeys.keys =
          ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUUC3kya8Ft2EafiA+4EyivIrOI6X++VkhCig93Yzhq mateusz@Orion"]
          ++ lib.optionals cfg.mat matKeys;
      };
    })

    (lib.mkIf cfg.kelvas {
      users.users.kelvas = {
        isNormalUser = true;
        uid = 1002;
        shell = pkgs.zsh;
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
        openssh.authorizedKeys.keys =
          ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNNLMQFqQvcw2/OyVIsKTxi8WUqcBKFIcYGwZZYM3DT2wQ3uJ1Z2u5KGoJI9DEaf8nZPsIsQnYHNAwYqeMbxdgenLgbtJmS2Afxzv7wD/3w/Ydn2HTTLMmm7gUbJ7RT3NWo5nYHhBTXiPmuYCGJ5TggbXuZhT3kN4Gy5czItpIQlDHUzVrgYbvkUQEhxB+rt5bgwAtk2V8QGFaOo7qkXK3hlq/Ff3SLRvtXQo3v3wEUr7ULO/xkzp5go+Tn5iM0ZyTyzOyBqHmqZKeuCc3P087WuUNn7WH0qTwbQUrHS7anXv5AB23J/bf3A7OSmLx9oEyJQ42r5KRfG/SITjKo5VtrOMMn6sADjF2B7vbGBWisQVbIRdvtEdRhpPGfs7Cz0QCphjNlGCGdghSY2e51p/IUoWWUIA+m6AtACFXr2ZOSBzi4OL5GXpmFpV/dgY6T01CXKPfrkML6vGnw8kwLk7ERng6nn3Gpl1yOi+Bt07qzXu8OKJDP0EFv+BW/wMIFcU="]
          ++ lib.optionals cfg.mat matKeys;
      };
    })

    (lib.mkIf cfg.syam {
      users.users.syam = {
        isNormalUser = true;
        uid = 1003;
        shell = pkgs.zsh;
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
        openssh.authorizedKeys.keys =
          ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3nskcuXUBuIikiFZ1MT8L+srlSVJnARaLTNdfAGbmZ syam@megaera"]
          ++ lib.optionals cfg.mat matKeys;
      };
    })

    (lib.mkIf (cfg.mz || cfg.kelvas || cfg.syam) {
      programs.zsh.enable = true;
    })
    (lib.mkIf cfg.cerebre {
      users.groups.cerebre = {};
      users.users.cerebre = {
        isSystemUser = true;
        group = "cerebre";
        description = "Restic backup user for friend";
        home = "/mnt/ehdd/cerebre";
        shell = "${pkgs.shadow}/bin/nologin";
        openssh.authorizedKeys.keys =
          [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXoZPjHGfkAAaSqg8/p9R1920caIw0vkHywAtck3kYl"
          ]
          ++ lib.optionals cfg.mat matKeys;
      };
    })
  ]);
}
