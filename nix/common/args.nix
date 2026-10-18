{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    options.commonArgs = lib.mkOption {
      type = lib.types.attrs;
      default = {
        env =
          {CGO_ENABLED = 1;}
          // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
            # Use Apple's system-library stubs for portable release binaries.
            NIX_LDFLAGS = "-L${pkgs.apple-sdk.src}/usr/lib";

            # Frida uses a versioned macOS triple for the same Darwin target.
            NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = 1;
          };

        # Set the target after stdenv's default, before dependency hooks run.
        preHook = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
          export MACOSX_DEPLOYMENT_TARGET=11.0
        '';

        nativeBuildInputs = with config.build;
        with llvm.packages;
          [
            clang
            bintools
            go
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
            pkgs.swift
            pkgs.darwin.sigtool
          ];
      };
    };
  };
}
