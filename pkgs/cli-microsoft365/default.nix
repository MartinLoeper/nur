{ lib
, stdenv
, pkgs
, fetchFromGitHub
, system ? builtins.currentSystem
, ...
}:

let
  nodejs = pkgs.nodejs_18;
  nodePackages = import ./node2nix {
    inherit pkgs system nodejs;
  };
  nodeDependencies = nodePackages.nodeDependencies;
in
stdenv.mkDerivation
{
  pname = "cli-microsoft365";
  version = "7.6.0";
  src = fetchFromGitHub {
    owner = "pnp";
    repo = "cli-microsoft365";
    rev = "v7.6.0";
    #hash = "";
  };

  buildInputs = with pkgs; [ nodejs makeWrapper ];

  buildPhase = ''

  '';

  meta = with lib; {
    homepage = "https://pnp.github.io/cli-microsoft365";
    description = "CLI for Microsoft 365";
    longDescription = ''
      Using the CLI for Microsoft 365, you can manage your Microsoft 365 tenant and SharePoint Framework projects on any platform. No matter if you are on Windows, macOS or Linux, using Bash, Cmder or PowerShell, using the CLI for Microsoft 365 you can configure Microsoft 365, manage SharePoint Framework projects and build automation scripts.
    '';
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "m365";
  };
}
