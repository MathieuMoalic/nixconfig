{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "wifi-menu";
    text = ''
      bssid=$( ${pkgs.networkmanager}/bin/nmcli -f SSID,RATE,BARS,SECURITY dev wifi list | sed -n '1!p' | cut -b 9- | ${pkgs.rofi-wayland}/bin/rofi -dmenu -p " " | cut -d' ' -f1)

      [ -z "$bssid" ] && exit

      password=$(echo "" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -p " " )

      [ -z "$password" ] && exit

      icon=/etc/nixos/hm-modules/icons/wifi-icon.png
      iconE=/etc/nixos/hm-modules/icons/error-warning.png

      # Notify the status
      notify_connect() {
        status=$?
        wifi_network=$( ${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi | grep -E '^yes' | cut -d\' -f2 | sed 's/^[^:]*://')

        if [[ "$status" == '0' ]]; then
          ${pkgs.dunst}/bin/dunstify -u low --replace=69 -i "$icon" "Connected to Network: $wifi_network"
        elif [[ "$status" -gt '0' ]]; then
          ${pkgs.dunst}/bin/dunstify -u low --replace=69 -i "$iconE" "Unable to Connect: Incorrect Passphrase"
        fi
      }

      # Connect to the Wifi & Display status
      ${pkgs.networkmanager}/bin/nmcli device wifi connect "$bssid" password "$password" ; notify_connect
    '';
  };
in {
  home.packages = [
    script
  ];
}
