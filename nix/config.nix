top @ {lib, ...}: let
  cfg = builtins.fromJSON (builtins.readFile "${top.config.src}/nix/config.json");
in {
  options.frida = lib.mkOption {
    type = lib.types.submodule {
      options = {
        repository = lib.mkOption {type = lib.types.str;};
        commit = lib.mkOption {type = lib.types.str;};
        version = lib.mkOption {type = lib.types.str;};
        gum_commit = lib.mkOption {type = lib.types.str;};
        deps_version = lib.mkOption {type = lib.types.str;};
        targets = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule {
            options = {
              runner = lib.mkOption {type = lib.types.str;};
              host = lib.mkOption {type = lib.types.str;};
              go_target = lib.mkOption {type = lib.types.str;};
              sdk_hash = lib.mkOption {type = lib.types.str;};
              toolchain_hash = lib.mkOption {type = lib.types.str;};
            };
          });
        };
      };
    };
  };

  config = {
    inherit (cfg) frida;

    perSystem = {pkgs, ...}: {
      options.build = {
        llvm.packages = lib.mkOption {
          type = lib.types.attrs;
          default = pkgs.llvmPackages_latest;
        };

        go = lib.mkOption {
          type = lib.types.package;
          default = pkgs.go_1_27;
        };
      };
    };
  };
}
