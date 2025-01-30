{config, ...}: let
  theme = config.colorScheme.palette;
in {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font Mono:size=13";
        selection-target = "both";
      };
      cursor = {
        style = "beam";
        blink = "yes";
        beam-thickness = 2.5;
      };
      colors = {
        alpha = 0.95;
        background = theme.base00;
        foreground = theme.base05;
        regular0 = theme.base00;
        regular1 = theme.base08;
        regular2 = theme.base0B;
        regular3 = theme.base0A;
        regular4 = theme.base0D;
        regular5 = theme.base0E;
        regular6 = theme.base0C;
        regular7 = theme.base05;
        bright0 = theme.base03;
        bright1 = theme.base09;
        bright2 = theme.base01;
        bright3 = theme.base02;
        bright4 = theme.base04;
        bright5 = theme.base06;
        bright6 = theme.base0F;
        bright7 = theme.base07;
      };
      "key-bindings" = {
        "clipboard-paste" = "Control+v XF86Paste";
      };
    };
  };
}
