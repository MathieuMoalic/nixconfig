{pkgs, ...}: {
  home.shellAliases = {
    wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
    py = "nix develop $HOME/gh/micromamba/env";
    man = "${pkgs.bat-extras.batman}/bin/batman";
    rl = "exec zsh -l";
    rm = " rm -vdrf";
    cp = "cp -r";
    mkdir = " mkdir -p";
    l = "exa -al --across --icons -s age";
    ll = "exa -ahlg --across --icons -s age";
    lt = "l --tree";
    e = "$EDITOR";
    m = "amumax";
    op = "xdg-open";
    se = "sudoedit";
    pm = "podman";
    cat = "bat -Pp";
    pmps = "pm ps -a  --sort status --format \"table {{.Names}} {{.Status}} {{.Created}} {{.Image}}\"";
    sysu = "systemctl --user";
    cd = "z";
    d = "z";
    tldr = "tldr -q";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    myip = "curl ifconfig.me; echo";
    dev = "nix develop -c zsh";
    ghs = "gh copilot suggest -t shell";
    ghe = "gh copilot explain";
    ghc = "gh copilot";
    colors = "curl -Ls 'https://raw.githubusercontent.com/NNBnh/textart-collections/main/color/colortest.textart' | bash; echo";
    lg = "lazygit";
    # teams = "nohup teams-for-linux --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 &";
  };
}
