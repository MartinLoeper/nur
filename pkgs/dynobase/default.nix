{ lib, stdenv, pkgs, fetchurl, appimageTools, ... }:

let
  pname-base = "dynobase";
  version = "2.3.0";
  appImage = appimageTools.wrapType2 {
    inherit version;
    pname = "${pname-base}-wrapped";

    src = fetchurl {
      url = "dynobase-${version}-build-230416d1lkzhd17.AppImage";
      hash = "sha256-VVVHcWnoZxlgzL13EnCKcymyas4CqfdLptcI8raT4PA=";
    };
  };
  desktopFile = pkgs.substituteAll {
    inherit version;
    src = ./share/applications/dynobase.desktop;
    exec = "${appImage}/bin/${appImage.name}";
    icon = ./share/icons/icon.jpg;
  };
  xdgDirectory = stdenv.mkDerivation {
    inherit version;
    pname = "${pname-base}-xdg";
    src = desktopFile;

    installPhase = ''
      install -d $out/share/applications

      cp $src $out/share/applications
    '';
    unpackPhase = ":";
  };
  appImageWrapper = (pkgs.writeShellScriptBin "dynobase" "exec -a $0 ${appImage}/bin/${appImage.name} $@");
in
pkgs.symlinkJoin
{
  pname = pname-base;
  inherit version;
  paths = [ appImageWrapper xdgDirectory ];

  meta = with lib; {
    homepage = "https://dynobase.dev/";
    description = "Professional GUI Client for DynamoDB";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "dynobase";
  };
}
