{
  description = "Hello World Eiffel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Note: Eiffel compiler not available in nixpkgs
            # Manual installation required
          ];

          shellHook = ''
            echo "🏰 Hello Eiffel Environment"
            echo "Note: Eiffel compiler needs manual installation"
            echo "This is a placeholder environment"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-eiffel" ''
            echo "Eiffel compiler not available in nixpkgs"
            echo "Manual installation required for EiffelStudio"
            cat ${./hello.e}
          ''}";
        };
      });
}