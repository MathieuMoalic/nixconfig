{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.flaresolverr;
in {
  options.myModules.flaresolverr = {
    enable = lib.mkEnableOption "flaresolverr";
  };

  config = lib.mkIf cfg.enable {
    services = {
      flaresolverr.port = 8191;
      flaresolverr.enable = true;
    };
  };
}
