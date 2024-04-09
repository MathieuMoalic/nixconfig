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
  xdg.desktopEntries = {
    firefox = {
      name = "Firefox";
      genericName = "Web Browser";
      exec = "firefox %U";
      terminal = false;
      categories = ["Application" "Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml"];
    };
    teams = {
      name = "Teams (Wayland)";
      genericName = "Unofficial Microsoft Teams client for Linux";
      exec = "teams-for-linux --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "teams-for-linux";
      terminal = false;
      categories = ["Network" "InstantMessaging" "Chat"];
    };
    code = {
      name = "Code (Wayland)";
      genericName = "Text Editor";
      exec = "code %F  --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "vscode";
      terminal = false;
      categories = ["Utility" "TextEditor" "Development" "IDE"];
      mimeType = ["text/plain" "inode/directory"];
    };
  };
}
