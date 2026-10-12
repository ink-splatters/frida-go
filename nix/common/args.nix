{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    options.commonArgs = lib.mkOption {
      type = lib.types.attrs;
      default = {
        buildInputs = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [pkgs.apple-sdk_15];

        env = {
          CGO_ENABLED = 1;
          GOWORK = "off";
        };

        nativeBuildInputs = with config.build;
        with llvm.packages;
          [
            clang
            bintools
            go
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [pkgs.swift];
      };
    };
  };
}
