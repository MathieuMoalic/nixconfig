{ inputs, ... }: {
  imports = [ inputs.xremap-flake.homeManagerModules.default ];
  services.xremap = {
    withHypr = true;
    yamlConfig = ''
      keymap:
        - remap:
            CapsLock-a: left
            CapsLock-d: right
            CapsLock-w: up
            CapsLock-s: down
    '';
  };
}
# virtual_modifiers: 
#   - CapsLock keymap: 
#     - remap: 
#       CapsLock-h: Left 
#       CapsLock-j: Down 
#       CapsLock-k: Up 
#       CapsLock-l: Right
