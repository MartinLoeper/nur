{ stdenv
, fetchurl
, lib
, buildFHSUserEnv
, dpkg
, autoPatchelfHook
, xorg
, dbus
, at-spi2-atk
, cups
, nss
, cairo
, libdrm
, gtk3
, mesa
, alsaLib
, writeShellScript
}:

let
  wifiman-source = stdenv.mkDerivation
    rec {
      name = "wifiman-desktop-source";
      version = "0.3.0";

      src = fetchurl {
        url = "https://desktop.wifiman.com/wifiman-desktop-${version}-linux-amd64.deb";
        sha256 = "sha256-ZGjTCewURJFJ3k8DaB5VxeaGJ9cnRh5x5j69ioyFgLM=";
      };

      buildInputs = [
        dpkg
        xorg.libXcomposite
        dbus
        at-spi2-atk
        cups
        nss
        cairo
        libdrm
        gtk3
        mesa
        alsaLib
      ];

      nativeBuildInputs = [
        autoPatchelfHook
      ];

      unpackPhase = ''
        install -d $out
        dpkg -x $src unpacked
        cp -r unpacked/* $out/
        mv "$out/opt/WiFiman Desktop" "$out/opt/wifiman"
      '';
    };
in
buildFHSUserEnv {
  name = "wifiman-desktop";
  targetPkgs = pkgs: [ wifiman-source ];
  # dontUnpack = true;
  # multiPkgs = pkgs: [ dpkg ];
  runScript = writeShellScript "start.sh" ''
    bash
    #/opt/wifiman/wifiman-desktop
  '';
  extraInstallCommands = ''
    ln -s /opt/wifiman/tmp /tmp
  '';
  # meta = with lib; {
  #   homepage = "https://ui.com/download/app/wifiman-desktop";
  #   platforms = [ "x86_64-linux" ];
  # };
}

