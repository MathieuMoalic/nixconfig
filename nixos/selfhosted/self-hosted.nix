{
  flake.nixosModules.self-hosted = {
    inputs,
    self,
    ...
  }: {
    imports = with self.nixosModules; [
      inputs.homepage.nixosModules.homepage-service
      inputs.pleustradenn.nixosModules.pleustradenn-service
      inputs.blaz.nixosModules.blaz-service
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
      pleustradenn
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
    ];
  };
}
