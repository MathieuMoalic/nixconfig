{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = "FiraCode Nerd Font Medium 10";
    extraConfig = {
      display-drun = "Applications:";
      display-window = "Windows:";
      drun-display-format = "{name}";
      modi = "window,run,drun";
      show-icons = true;
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        "background-color" = mkLiteral "@bg";
        border = mkLiteral "0";
        margin = mkLiteral "0";
        padding = mkLiteral "0";
        spacing = mkLiteral "0";
        bg = mkLiteral "#11121D";
        "bg-alt" = mkLiteral "#444b6a";
        fg = mkLiteral "#FFFFFF";
        "fg-alt" = mkLiteral "#787c99";
      };
      window = {
        width = mkLiteral "30%";
      };
      element = {
        padding = mkLiteral "8 0";
        "text-color" = mkLiteral "@fg-alt";
      };
      "element selected" = {
        "text-color" = mkLiteral "@fg";
      };
      "element-text" = {
        "background-color" = mkLiteral "inherit";
        "text-color" = mkLiteral "inherit";
        "vertical-align" = mkLiteral "0.5";
      };
      "element-icon" = {
        size = mkLiteral "30";
        padding = mkLiteral "0 10px 0 0";
      };
      entry = {
        "background-color" = mkLiteral "@bg-alt";
        padding = mkLiteral "12";
        "text-color" = mkLiteral "@fg";
      };
      inputbar = {
        children = map mkLiteral ["prompt" "entry"];
      };
      listview = {
        padding = mkLiteral "8 12";
        "background-color" = mkLiteral "@bg";
        columns = mkLiteral "1";
        lines = mkLiteral "8";
      };
      mainbox = {
        "background-color" = mkLiteral "@bg";
        children = map mkLiteral ["inputbar" "listview"];
      };
      prompt = {
        "background-color" = mkLiteral "@bg-alt";
        enabled = mkLiteral "true";
        padding = mkLiteral "12 0 0 12";
        "text-color" = mkLiteral "@fg";
      };
    };
  };
}
