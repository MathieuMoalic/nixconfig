{config, ...}: {
  services = {
    syncthing = {
      enable = true;
      user = "mat";
      group = "mat";
      dataDir = "/home/mat/sync"; # Default folder for new synced folders
      configDir = "/home/mat/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      openDefaultPorts = true;
      relay = {
        enable = true;
      };
      settings = {
        devices = {
          homeserver = {
            autoAcceptFolders = true;
            id = "3K5PK4F-EFK2CJG-FDNJSQP-S23BN3I-FBPTNGA-IF7IQCL-O4LOVL6-JLOTUQE";
          };
          oneplus = {
            id = "PXOELPW-AQXMEXD-7DCHW6O-ID54IYY-T2U35KM-YPU657P-6IBPJDY-ENFH3AP ";
            autoAcceptFolders = true;
          };
          xps = {
            id = "GCEPPMO-ZGT2AK3-3Y7C55R-YVZMZ4U-WJMGPL7-RDPQOEI-L3TMRVN-W2E6DAX";
            autoAcceptFolders = true;
          };
          nyx = {
            id = "Y5XKMHT-3T7OOE6-EESSVJ3-ZDRENEA-64HKJ64-MP34CAO-CKDHAVG-EKLUKQI";
            autoAcceptFolders = true;
          };
        };
        folders = {
          docs = {
            path = "/home/mat/sync/docs";
            id = "docs";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
            devices = ["homeserver" "xps" "nyx" "oneplus"];
          };
          classes = {
            path = "/home/mat/sync/classes";
            id = "classes";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
            devices = ["homeserver" "xps" "nyx"];
          };
          phone_camera = {
            path = "/home/mat/sync/phone_camera";
            id = "phone_camera";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
            devices = ["homeserver" "xps" "nyx" "oneplus"];
          };
        };
      };
    };
  };
}
