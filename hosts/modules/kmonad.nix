{config, ...}: let
  keyboardDevices = {
    "nyx" = "/dev/input/by-id/usb-Dwctor_kaly_kaly42_32005D00165133353238323100000000-event-kbd";
    "xps" = "/dev/input/by-id/";
    "zagreus" = "/dev/input/by-id/";
  };
in {
  services.kmonad = {
    enable = true;
    keyboards."en-pl-fr" = {
      device = builtins.getAttr config.networking.hostName keyboardDevices;
      defcfg.fallthrough = true;
      defcfg.enable = true;
      config = ''
        (defalias
          pl (tap-next g (layer-toggle pl-layer))
          fr (tap-next f (layer-toggle fr-layer))
        )

        (defsrc
          q    w    e    r    t    y    u    i    o    p
          a    s    d    f    g    h    j    k    l
          z    x    c    v    b    n    m
        )

        (deflayer base
          q     w    e    r    t    y    u    i    o    p
          a     s    d    @fr  @pl  h    j    k    l
          z     x    c    v    b    n    m
        )

        (deflayer pl-layer
          q     w    ę    r    t    y    u    i    ó    p
          ą     ś    d    f    g    h    j    k    ł
          ż     ź    ć    v    b    ń    m
        )

        (deflayer fr-layer
          â     ê    é    r    t    ÿ    ù    î    ô    ö
          à     è    ë    f    g    h    û    ï    l
          ä     x    ç    v    b    n    ü
        )
      '';
    };
  };
}
