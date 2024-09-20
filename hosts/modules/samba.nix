{
  pkgs,
  config,
  ...
}: {
  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = [pkgs.cifs-utils];
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  fileSystems."/home/mat/nas" = {
    device = "//150.254.111.48/zfn";
    fsType = "cifs";
    options = ["x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users,credentials=${config.sops.templates.samba.path},uid=1000,gid=1000"];
  };

  sops.secrets = {
    samba = {};
  };
  sops.templates.samba.content = ''
    username=matmoa
    password=${config.sops.placeholder.samba}
  '';
}
