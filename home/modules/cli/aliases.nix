{pkgs, ...}: {
  programs.nushell.shellAliases = {
    wget = "wget --hsts-file=$env.XDG_DATA_HOME/wget-hsts";
    man = "${pkgs.bat-extras.batman}/bin/batman";
    rm = " rm -vrf";
    l = "exa -al --across --icons -s age";
    ll = "exa -algh --across --icons -s age";
    lt = "exa -al --across --icons -s age --tree";
    e = "nvim";
    m = "amumax";
    op = "xdg-open";
    pm = "podman";
    pmps = "pm ps -a  --sort status --format \"table {{.Names}} {{.Status}} {{.Image}}\"";
    sysu = "systemctl --user";
    cd = "z";
    tldr = "tldr -q";
    myip = "curl ifconfig.me; echo";
    lg = "lazygit";
    mv = "rclone moveto -P";
    cp = "rclone copyto -P";
    sopsedit = "SOPS_AGE_KEY_FILE=/home/mat/.ssh/age_key sops /home/mat/nix/secrets.yaml";
  };
}
