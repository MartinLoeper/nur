{ lib, stdenv, pkgs, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  pname = "mkusb-nox";
  version = "23.1.2";

  src = fetchTarball
    {
      url = "https://github.com/sudodus/tarballs/raw/master/mkusb-nox.tar.xz";
      sha256 = "sha256:0kyli7xgdvb6wg5g48hjgp5yl3i8wkrvnwhhav955bi5sqs4xs8r";
    };

  buildInputs = with pkgs; [
    pv
  ];

  unpackPhase = ":";
  installPhase = ''
    install -d $out/bin
    cp $src $out/bin/mkusb-nox
  '';

  meta = with lib; {
    homepage = "https://help.ubuntu.com/community/mkusb/v7";
    description = "Copy an ISO file to a USB device";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mkusb-nox";
  };
}
