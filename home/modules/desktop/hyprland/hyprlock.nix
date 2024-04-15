{...}: {
  xdg.configFile."hypr/hyprlock.conf".text = ''
    background {
        monitor =
        path = /home/mat/.local/share/wallpaper.png
        blur_passes = 3
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
    }

    general {
        no_fade_in = false
        grace = 0
        disable_loading_bar = true
    }

    input-field {
        monitor =
        size = 250, 60
        outline_thickness = 2
        dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true
        outer_color = rgba(0, 0, 0, 0)
        inner_color = rgba(0, 0, 0, 0.5)
        font_color = rgb(200, 200, 200)
        fade_on_empty = false
        # font_family = FiraCode Nerd Font Mono
        placeholder_text = <i><span foreground="##cdd6f4">Input Password...</span></i>
        hide_input = false
        position = 0, -20
        halign = center
        valign = center
    }

    label {
        monitor =
        text = cmd[update:1000] echo "$(date +"%Y-%m-%d %H:%M %Z")"
        # color = $foreground
        color = rgba(255, 255, 255, 0.6)
        font_size = 40
        font_family = FiraCode Nerd Font Mono
        position = 0, -400
        halign = center
        valign = top
    }

  '';
}
