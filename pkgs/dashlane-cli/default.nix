{ lib, stdenv, pkgs, fetchFromGitHub, system ? builtins.currentSystem, ... }: 

# TODO: add generate script for node2nix like e.g.: https://github.com/NixOS/nixpkgs/blob/f8d3c2dabdab26f53fe95079d7725da777019ff2/pkgs/development/web/netlify-cli/generate.sh
let
  nodePackages = import ./node2nix {
    inherit pkgs system;
    nodejs = pkgs.nodejs_18;
  } // {
    "playwright" = nodePackages.playwrights.override {
      dontNpmInstall = true; # playwright-core-1.37.1
    };
  };

  nodeDependencies = nodePackages.nodeDependencies;
in
  nodeDependencies

# stdenv.mkDerivation {
#   pname = "dashlane-cli";
#   version = "1.13.0";

#   buildInputs = [pkgs.nodejs_18];
  
#   buildPhase = ''
#     ln -s ${nodeDependencies}/lib/node_modules ./node_modules
#     export PATH="${nodeDependencies}/bin:$PATH"

#     yarn run build
#     cp -r dist $out/
#   '';

#   meta = with lib; {
#     homepage = "https://github.com/Dashlane/dashlane-cli";
#     description = "A Dashlane CLI";
#     license = licenses.asl20;
#     platforms = [ "x86_64-linux" ];
#     mainProgram = "dcli";
#   };
# }