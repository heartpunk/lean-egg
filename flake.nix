{
  description = "lean-egg dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    lean4-nix.url = "github:lenianiva/lean4-nix";
  };

  outputs = { self, nixpkgs, lean4-nix }:
    let
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (lean4-nix.readToolchainFile ./lean-toolchain) ];
          };
        in {
          default = pkgs.mkShell {
            packages = [
              pkgs.lean
              pkgs.cargo
              pkgs.rustc
              pkgs.git
            ];
          };
        });
    };
}
