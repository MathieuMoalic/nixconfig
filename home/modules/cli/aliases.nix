{...}: {
  programs.fish = {
    shellAliases = {};
    shellAbbrs = {
      cd = "z";
      lg = "lazygit";
      rm = "trash -vrf";
      cp = "cp -r";
      l = "eza -al --across --icons -s age";
      ll = "eza -algh --across --icons -s age";
      lt = "eza -al --across --icons -s age --tree";
      e = "nvim";
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
