{config, ...}: let
  port = 10011;
  client_addr = "ys.matmoa.eu";
  server_addr = "ys-api.matmoa.eu";
in {
  sops.secrets."your-spotify/secret" = {
    owner = "your_spotify";
    group = "your_spotify";
    mode = "0400";
  };
  services.caddy = {
    virtualHosts = {
      "${client_addr}" = {
        extraConfig = ''reverse_proxy localhost:${toString port}'';
      };
      "${server_addr}" = {
        extraConfig = ''reverse_proxy localhost:${toString port}'';
      };
    };
  };
  services.your_spotify = {
    enable = true;
    enableLocalDB = true;
    nginxVirtualHost = "${client_addr}";
    spotifySecretFile = config.sops.secrets."your-spotify/secret".path;
    settings = {
      CLIENT_ENDPOINT = "https://localhost:${toString port}";
      API_ENDPOINT = "https://${server_addr}";
      SPOTIFY_PUBLIC = "629ff9eb1fc847ea9d6e48ca35733a41";
      PORT = port;
    };
  };
}
