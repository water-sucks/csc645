{
  description = "Varun's CSC-510 HW at SFSU";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          name = "csc510-shell";
          packages = with pkgs; [
            typst
            typst-fmt

            go
            golangci-lint

            (python3.withPackages
              (ps: [
                ps.scapy
              ]))
          ];
        };
      };
    };
}
