{...}: {
  services = {
    syncthing = {
      enable = true;
      user = "mat";
      group = "mat";
      dataDir = "/home/mat/sync"; # Default folder for new synced folders
      configDir = "/home/mat/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      # overrideDevices = true; # overrides any devices added or deleted through the WebUI
      # overrideFolders = true; # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "homeserver" = {
            # autoAcceptFolders = true;
            id = "K7UHOBQ-DCDAJRE-DHCTO6M-GGLSN47-6MTRMQC-IP2HURQ-5DDY5Y5-S4O6NQZ";
          };
          # "oneplus" = {
          #   id = "PXOELPW-AQXMEXD-7DCHW6O-ID54IYY-T2U35KM-YPU657P-6IBPJDY-ENFH3AP ";
          #   autoAcceptFolders = true;
          # };
        };
        # folders = {
        #   "test1" = {
        #     path = "/home/mat/test1";
        #     devices = ["homeserver" "oneplus"];
        #   };
        # };
      };
    };
  };
}
