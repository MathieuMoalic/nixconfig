{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    module1.enable =
      lib.mkEnableOption "enables module1";
  };

  config = lib.mkIf config.module1.enable {
    option1 = 5;
    option2 = true;
    services.blueman.enable = true;

    environment.etc."hi".text = ''
      nameserver 109.173.160.203
      nameserver 1.1.1.1'';
  };
}
