{
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) pre-commit commonArgs;
  in {
    devShells.default =
      pkgs.mkShell.override {inherit (config.build.llvm.packages) stdenv;}
      (commonArgs
        // {
          nativeBuildInputs =
            commonArgs.nativeBuildInputs
            ++ pre-commit.settings.enabledPackages
            ++ (with pkgs; [
              python3
              git
              nodejs
              which
              gh
              actionlint
              shellcheck
            ]);

          shellHook = pre-commit.installationScript;
        });
  };
}
