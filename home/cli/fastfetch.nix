{
  flake.homeModules.fastfetch = {...}: {
    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          source = "none"; # Hides the big OS ASCII logo
        };

        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "terminal"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "battery"
          "break"
        ];
      };
    };
  };
}
