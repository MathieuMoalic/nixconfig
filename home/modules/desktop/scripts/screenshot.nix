{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "sc";
    text = ''
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" -t ppm - | ${pkgs.satty}/bin/satty --filename - \
      --output-filename /tmp/satty-"$(date '+%Y%m%d-%H:%M:%S')".png \
      --initial-tool brush'';
  };
in {
  home.packages = [
    script
  ];
}
