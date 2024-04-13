{...}: {
  xdg.desktopEntries = {
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
