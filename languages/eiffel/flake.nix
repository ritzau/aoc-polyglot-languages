{
  description = "Eiffel environment for AOC solutions";

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
            # Note: Eiffel might not be available in nixpkgs
            # You may need to build from source or use a different approach
          ];

          shellHook = ''
            echo "🏰 Eiffel AOC Environment"
            echo "Note: Eiffel compiler may need to be installed manually"
            echo "Available commands (if EiffelStudio is installed):"
            echo "  ec -config system.ecf"
            echo "  compile_all"
          '';
        };
      });
}
