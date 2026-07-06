{
  flake.nixosModules.lemurs = {
    pkgs,
    config,
    lib,
    ...
  }: let
    onlyHyprlandUwsmSessions = pkgs.runCommand "lemurs-hyprland-uwsm-sessions" {} ''
      mkdir -p $out/share/wayland-sessions

      ln -s \
        ${config.programs.hyprland.package}/share/wayland-sessions/hyprland-uwsm.desktop \
        $out/share/wayland-sessions/hyprland-uwsm.desktop
    '';
  in {
    services.displayManager.lemurs = {
      enable = true;

      settings.wayland.wayland_sessions_path =
        lib.mkForce "${onlyHyprlandUwsmSessions}/share/wayland-sessions";
    };
  };
}
