{...}: {
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "Alex";
        password = "foo";
        device_name = "nix";
      };
    };
  };
}
