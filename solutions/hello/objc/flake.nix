{
  description = "Hello World Objective-C";

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
            clang
            gnustep-base
            gnustep-make
            libobjc
          ];

          shellHook = ''
            echo "🍎 Hello Objective-C Environment"
            echo "Run: clang -framework Foundation hello.m -o hello-objc"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-objc" ''
            cd ${./.}
            ${pkgs.clang}/bin/clang -framework Foundation hello.m -o hello-objc
            ./hello-objc
          ''}";
        };
      });
}