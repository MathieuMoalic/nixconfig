{config, ...}: {
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/dl";
    documents = "${config.home.homeDirectory}/dl";
    download = "${config.home.homeDirectory}/dl";
    music = "${config.home.homeDirectory}/dl";
    pictures = "${config.home.homeDirectory}/dl";
    publicShare = "${config.home.homeDirectory}/dl";
    templates = "${config.home.homeDirectory}/dl";
    videos = "${config.home.homeDirectory}/dl";
  };
  # xdg.desktopEntries = {
  #   firefox = {
  #     name = "Firefox";
  #     genericName = "Web Browser";
  #     exec = "firefox %U";
  #     terminal = false;
  #     categories = ["Application" "Network" "WebBrowser"];
  #     mimeType = ["text/html" "text/xml"];
  #   };
  # };
}
