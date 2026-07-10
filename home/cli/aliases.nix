{
  flake.homeModules.aliases = {...}: {
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
        e = "hx";
        op = "xdg-open";
        tldr = "tldr -q";
        myip = "curl ifconfig.me; echo";
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
        "......" = "../../../../..";
      };
    };
  };
}
