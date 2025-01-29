{...}: {
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      dialect = "uk";
      update_check = false;
      style = "compact";
      inline_height = 10;
      ctrl_n_shortcuts = true;
      history_filter = [
        "^ *$"
        "^*secret*$"
        "^*password*$"
      ];
    };
  };
}
