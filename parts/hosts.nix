{lib, ...}: {
  options.my.hosts = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = {};
    description = "Host module entrypoints (paths) used to build nixosConfigurations.";
  };

  config.my.hosts = {
    xps = ../hosts/xps.nix;

    nyx = ../hosts/nyx.nix;
    homeserver = ../hosts/homeserver.nix;
    zeus = ../hosts/zeus.nix;
    alecto = ../hosts/alecto.nix;
    zagreus = ../hosts/zagreus.nix;
    kiosk = ../hosts/kiosk.nix;
  };
}
