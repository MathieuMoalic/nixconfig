{pkgs, ...}: let
  pythonWithPackages = pkgs.python3.withPackages (ps:
    with ps; [
      requests
      tkinter
      xdg-base-dirs
    ]);

  quick-translate = pkgs.writeScriptBin "quick-translate" ''
    #!${pythonWithPackages}/bin/python
    import subprocess
    import requests
    import tkinter as tk
    from tkinter import ttk
    from xdg_base_dirs import xdg_config_home
    import configparser

    config = configparser.ConfigParser()
    config_path = xdg_config_home().joinpath("deeplinux/deeplinux.toml")
    config.read(config_path)

    DEEPL_AUTH_KEY = config['deeplinux']['deepl_auth_key']
    DEEPL_API_ENDPOINT = config['deeplinux']['deepl_api_endpoint']
    TARGET_LANG = config['deeplinux']['TARGET_LANG']

    def get_selected_text():
        return subprocess.check_output(["xclip", "-o", "-selection", "primary"]).decode(
            "utf-8"
        )


    def translate_text(text):
        headers = {"Authorization": f"DeepL-Auth-Key {DEEPL_AUTH_KEY}"}
        data = {"text": text, "target_lang": TARGET_LANG}

        response = requests.post(DEEPL_API_ENDPOINT, headers=headers, data=data)
        if response.status_code == 200:
            return response.json()["translations"][0]["text"]
        else:
            raise Exception(f"Error: {response.text}")


    def display_translation(text):
        root = tk.Tk()
        root.title("Translation")

        # Dracula color theme
        BG_COLOR = "#282a36"
        FG_COLOR = "#f8f8f2"
        BORDER_COLOR = "#6272a4"

        # Remove window decorations to make it lightweight
        root.overrideredirect(True)
        root.configure(bg=BORDER_COLOR)

        # Set the window near the mouse cursor
        x, y = root.winfo_pointerx(), root.winfo_pointery()

        # Create a label to display the translation
        label = ttk.Label(
            root,
            text=text,
            padding=10,
            background=BG_COLOR,
            foreground=FG_COLOR,
            wraplength=200,
        )
        label.pack(
            padx=2, pady=2, fill=tk.BOTH, expand=True
        )  # padding for the border effect

        # Adjust window size to fit text
        root.update_idletasks()
        width = label.winfo_width() + 4  # 4 for the border effect
        height = label.winfo_height() + 4

        # Ensure the tooltip does not extend beyond screen boundaries
        screen_width = root.winfo_screenwidth()
        screen_height = root.winfo_screenheight()
        x = x if x + width < screen_width else screen_width - width
        y = y if y + height < screen_height else screen_height - height

        root.geometry(f"{width}x{height}+{x}+{y}")

        # Close the window on any keypress or mouse click
        root.bind("<Key>", lambda e: root.destroy())
        root.bind("<Button>", lambda e: root.destroy())

        root.mainloop()


    def main():
        selected_text = get_selected_text()
        translated_text = translate_text(selected_text)
        display_translation(translated_text)


    if __name__ == "__main__":
        main()
  '';
in {
  home.packages = [
    quick-translate
    pkgs.wl-clipboard-x11
  ];
}
