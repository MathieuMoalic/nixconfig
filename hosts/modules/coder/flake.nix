{
  description = "A simple flake for the coder package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # Import nixpkgs with configuration allowing unfree packages
    pkgs = import nixpkgs {
      system = "x86_64-linux"; # Specify the system type
      config.allowUnfree = true; # Allow unfree packages
    };

    # Inherit necessary packages and libraries from the imported pkgs
    inherit (pkgs) lib fetchurl installShellFiles makeBinaryWrapper stdenvNoCC unzip;
    version = "2.9.1";
  in {
    defaultPackage.x86_64-linux = stdenvNoCC.mkDerivation {
      pname = "coder";
      version = version;

      src = fetchurl {
        hash = "sha256-r4+u/s/dOn2GhyhEROu8i03QY3VA/bIyO/Yj7KSqicY=";
        url = "https://github.com/coder/coder/releases/download/v${version}/coder_${version}_linux_amd64.tar.gz";
      };

      nativeBuildInputs = [installShellFiles makeBinaryWrapper unzip];

      unpackPhase = ''
        runHook preUnpack
        tar -xz -f "$src"
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        install -D -m755 coder $out/bin/coder
        runHook postInstall
      '';

      postInstall = ''
        installShellCompletion --cmd coder \
          --bash <($out/bin/coder completion bash) \
          --fish <($out/bin/coder completion fish) \
          --zsh <($out/bin/coder completion zsh)
        wrapProgram $out/bin/coder \
          --prefix PATH : terraform
      '';

      doCheck = false;

      meta = {
        description = "Provision remote development environments via Terraform";
        homepage = "https://coder.com";
        license = lib.licenses.agpl3Only;
        mainProgram = "coder";
        maintainers = with lib.maintainers; [ghuntley urandom];
      };
    };
  };
}
