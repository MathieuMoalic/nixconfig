{pkgs, ...}: {
  programs.nushell.shellAliases = {
    wget = "wget --hsts-file=$env.XDG_DATA_HOME/wget-hsts";
    man = "${pkgs.bat-extras.batman}/bin/batman";
    rm = " rm -vrf";
    cp = "cp -r";
    l = "exa -al --across --icons -s age";
    ll = "exa -ahlg --across --icons -s age";
    lt = "l --tree";
    e = "hx";
    m = "amumax";
    op = "xdg-open";
    se = "sudoedit";
    pm = "podman";
    pmps = "pm ps -a  --sort status --format \"table {{.Names}} {{.Status}} {{.Image}}\"";
    sysu = "systemctl --user";
    cd = "z";
    tldr = "tldr -q";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    myip = "curl ifconfig.me; echo";
    ghs = "gh copilot suggest -t shell";
    ghe = "gh copilot explain";
    ghc = "gh copilot";
    lg = "lazygit";
  };
}
