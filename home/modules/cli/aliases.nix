{...}: {
  programs.fish = {
    shellAliases = {cd = "z";};
    shellAbbrs = {
      lg = "lazygit";
      rm = " rm -vrf";
      l = "exa -al --across --icons -s age";
      ll = "exa -algh --across --icons -s age";
      lt = "exa -al --across --icons -s age --tree";
      e = "$EDITOR";
      m = "amumax";
      op = "xdg-open";
      pm = "podman";
      pmps = "podman ps -a --sort status --format \"table {{.Names}} {{.Status}} {{.Image}}\"";
      tldr = "tldr -q";
      myip = "curl ifconfig.me; echo";
      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../..";
      "......" = "../../../../..";
    };
  };
}
