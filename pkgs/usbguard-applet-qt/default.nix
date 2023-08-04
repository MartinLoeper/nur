{ stdenv, pkgs, ... }: 

stdenv.mkDerivation {
  name = "usbguard-applet-qt";

  src = fetchFromGitHub {
    owner = "pinotree";
    repo = "usbguard-applet-qt";
    rev = "6f32dd18addc986cce6c868febea55e86fc936d9";
    hash = "sha256-XXtir/sSjJ1rpv3UQHM3Kano/fMBch/sm8ZtYwGyFyQ=";
  };

  nativeBuildInputs = [ 
    pkgs.cmake 
    pkgs.pkg-config
  ];
  
  buildInputs = [
    pkgs.libsForQt5.full
  ];
}