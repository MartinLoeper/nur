{ lib, stdenv, pkgs, fetchFromGitHub, poetry2nix, ... }:

poetry2nix.mkPoetryApplication rec {
  pname = "aws-sso-credential-process";
  version = "0.3.0";
  projectDir = fetchFromGitHub {
    owner = "nesto-software";
    repo = "aws-sso-credential-process";
    rev = "ebc4a5a2c534159f24a36fee6c7fe5ee3e06e7f5";
    sha256 = "sha256-ruqrKFpaDb//uARXoXULiRqxYxK73SFF5zqi00qTkLw=";
  };
  format = "pyproject";
  poetrylock = ./poetry.lock;
  src = poetry2nix.cleanPythonSources { src = projectDir; };
  python = pkgs.python39;

  meta = with lib; {
    homepage = "https://github.com/benkehoe/aws-sso-credential-process";
    description = "Bring AWS SSO-based credentials to the AWS SDKs until they have proper support";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "aws-sso-credential-process";
  };
}
