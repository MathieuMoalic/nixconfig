{...}: {
  programs.fish = {
    shellAliases = {};
    shellAbbrs = {
      weather = "curl wttr.in/poznan";
      cd = "z";
      lg = "lazygit";
      rm = "trash -vrf";
      cp = "cp -r";
      l = "eza -al --across --icons -s age";
      ll = "eza -algh --across --icons -s age";
      lt = "eza -al --across --icons -s age --tree";
      e = "nvim";
      ef = "nvim -- (tv files --no-remote)";
      eg = "set -l p (string split -m2 ':' -- (tv text --no-remote)); test (count $p) -ge 2; and nvim +$p[2] -- $p[1]";
      m = "amumax";
      op = "xdg-open";
      pm = "podman";
      pmps = "podman ps -a --sort status --format \"table {{.Names}} {{.Status}} {{.Image}}\"";
      tldr = "tldr -q";
      myip = "curl ifconfig.me; echo";
      ipy = "ipython --no-banner --no-tip";
      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../..";
      "......" = "../../../../..";
    };
  };
}
