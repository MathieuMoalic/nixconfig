{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [rclone];
  home.shellAliases = {
    rmv = "rclone move --progress";
    rcp = "rclone copy --progress";
    rs = "rclone sync --progress --delete-after=false";
  };

  home.file.".config/rclone/rclone.conf".text = ''
    [faculty]
    type = sftp
    host = 150.254.111.35
    user = matmoa
    key_file = ~/.ssh/id_ed25519

    [pcss]
    type = sftp
    host = eagle.man.poznan.pl
    user = mathieum
    key_file = ~/.ssh/id_ed25519

    [homeserver]
    type = sftp
    host = matmoa.xyz
    user = mat
    port = 23232
    key_file = ~/.ssh/id_ed25519

    [nyx]
    type = sftp
    host = nyx.zfns.eu.org
    user = mat
    port = 46464
    key_file = ~/.ssh/id_ed25519

    [prometheus]
    type = sftp
    host = prometheus.zfns.eu.org
    user = matmoa
    port = 28561
    key_file = ~/.ssh/id_ed25519

    [zephyros]
    type = sftp
    host = zephyros.zfns.eu.org
    user = admin
    port = 23099
    key_file = ~/.ssh/id_ed25519

    [eos]
    type = sftp
    host = eos.zfns.eu.org
    user = matmoa
    port = 4545
    key_file = ~/.ssh/id_ed25519

    [zeus]
    type = sftp
    host = zeus.zfns.eu.org
    user = mat
    port = 46464
    key_file = ~/.ssh/id_ed25519
  '';
}
