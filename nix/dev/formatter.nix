{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.writeShellScriptBin "fmt-all" ''
      ${pkgs.alejandra}/bin/alejandra .
    '';
  };
}
