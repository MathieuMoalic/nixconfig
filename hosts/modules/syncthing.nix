{...}: {
  services = {
    syncthing = {
      enable = true;
      user = "mat";
      group = "mat";
      dataDir = "/home/mat/sync"; # Default folder for new synced folders
      configDir = "/home/mat/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      overrideDevices = false; # overrides any devices added or deleted through the WebUI
      overrideFolders = false; # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "homeserver" = {
            # autoAcceptFolders = true;
            id = "K7UHOBQ-DCDAJRE-DHCTO6M-GGLSN47-6MTRMQC-IP2HURQ-5DDY5Y5-S4O6NQZ";
          };
          "oneplus" = {
            id = "PXOELPW-AQXMEXD-7DCHW6O-ID54IYY-T2U35KM-YPU657P-6IBPJDY-ENFH3AP ";
            # autoAcceptFolders = true;
          };
        };
        folders = {
          docs = {
            path = "/home/mat/sync/docs";
            id = "docs";
            devices = ["homeserver" "oneplus"];
          };
          yt = {
            path = "/home/mat/sync/yt";
            id = "yt";
            devices = ["homeserver"];
          };
          pics = {
            path = "/home/mat/sync/pics";
            id = "pics";
            devices = ["homeserver"];
          };
          classes = {
            path = "/home/mat/sync/classes";
            id = "classes";
            devices = ["homeserver"];
          };
          oneplus = {
            path = "/home/mat/sync/oneplus";
            id = "oneplus";
            devices = ["homeserver"];
          };
        };
      };
    };
  };
}
