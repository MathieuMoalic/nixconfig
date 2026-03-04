{
  flake.nixosModules.self-hosted = {
    inputs,
    self,
    ...
  }: {
    imports = with self.nixosModules; [
      inputs.homepage.nixosModules.homepage-service
      inputs.blaz.nixosModules.blaz-service
      inputs.mont.nixosModules.mont-service
      inputs.boued.nixosModules.boued-service
      caddy
      scrutiny
      uptime-kuma
      immich
      synapse
      element-web
      authelia
      homepage
      ntfy
      libretranslate
      stirling-pdf
      vaultwarden
      jellyfin
      jellyseerr
      prowlarr
      sonarr
      radarr
      bazarr
      flaresolverr
      transmission
      watcharr
      blaz
      mont
    ];
  };
}
