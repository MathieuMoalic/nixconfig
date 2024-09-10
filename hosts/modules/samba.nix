{pkgs, ...}: {
  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = [pkgs.cifs-utils];
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  fileSystems."/home/mat/nas" = {
    device = "//150.254.111.48/zfn";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=1000"];
  };
}
