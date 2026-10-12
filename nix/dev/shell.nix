top @ {lib, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: let
    inherit (config) pre-commit commonArgs;
    inherit (top.config) frida;
    target = frida.targets.${system} or null;
    bundle = kind: hash:
      pkgs.fetchurl {
        url = "https://build.frida.re/deps/${frida.deps_version}/${kind}-${target.host}.tar.xz";
        inherit hash;
      };
  in {
    devShells.default =
      pkgs.mkShell.override {inherit (config.build.llvm.packages) stdenv;}
      (commonArgs
        // {
          packages =
            pre-commit.settings.enabledPackages
            ++ (with pkgs; [
              python3
              git
              nodejs
              ninja
              pkg-config
              gnumake
              gnutar
              xz
              gh
              actionlint
              ruff
            ]);

          shellHook = ''
            ${pre-commit.installationScript}
          '';

          env =
            commonArgs.env
            // lib.optionalAttrs (target != null) {
              FRIDA_BUILD_SYSTEM = system;
              FRIDA_SDK_ARCHIVE = bundle "sdk" target.sdk_hash;
              FRIDA_TOOLCHAIN_ARCHIVE = bundle "toolchain" target.toolchain_hash;
            };
        });
  };
}
