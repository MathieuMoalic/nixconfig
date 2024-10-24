{inputs, ...}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = {
    slug = "mydracula";
    name = "mydracula";
    author = "me";
    palette = {
      base00 = "#282a36"; # background
      base01 = "#69ff94"; # bright green
      base02 = "#ffffa5"; # bright yellow
      base03 = "#6272a4"; # bright black
      base04 = "#d6acff"; # bright blue
      base05 = "#f8f8f2"; # foreground
      base06 = "#ff92df"; # bright magenta
      base07 = "#ffffff"; # bright white
      base08 = "#ff5555"; # red
      base09 = "#ff6e6e"; # bright red
      base0A = "#f1fa8c"; # yellow
      base0B = "#50fa7b"; # green
      base0C = "#8be9fd"; # cyan
      base0D = "#bd93f9"; # blue
      base0E = "#ff79c6"; # magenta
      base0F = "#a4ffff"; # bright cyan
      orange = "#ffb86c"; # orange
      blue = "#6e9bcb"; # gray-blue
      hx-cursor-line = "#2d303e"; # dark gray
      hx-darker = "#222430"; # darker gray
      hx-black = "#191A21"; # black
      hx-grey = "#666771"; # light grey
      hx-current-line = "#44475a"; # grey
      hx-selection = "#363848"; # medium dark grey
      zellij-highlight = "#000000";
    };
  };
}
