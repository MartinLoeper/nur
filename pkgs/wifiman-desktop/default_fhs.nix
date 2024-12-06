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
, libvdpau-va-gl
, runCommand
, libglvnd
, gdb
}:

let
  mesa-drivers = [ mesa.drivers ];
  libvdpau = [ libvdpau-va-gl ];
  glxindirect = runCommand "mesa_glxindirect" { } (
    ''
      mkdir -p $out/lib
      ln -s ${mesa.drivers}/lib/libGLX_mesa.so.0 $out/lib/libGLX_indirect.so.0
    ''
  );
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
        ln -s /tmp $out/opt/wifiman/tmp
        #mkdir -p -m 777 $out/opt/wifiman/tmp
        chmod -R 777 $out/opt/wifiman/assets
      '';
    };
in
buildFHSUserEnv {
  name = "wifiman-desktop";
  targetPkgs = pkgs: [ wifiman-source ];
  # dontUnpack = true;
  multiPkgs = pkgs: [
    pkgs.glxinfo
    pkgs.mesa
  ];
  runScript = writeShellScript "start.sh" ''
    #export QT_QPA_PLATFORM=xcb
    #export LIBGL_ALWAYS_SOFTWARE=1
    #export GDK_BACKEND=x11
    #export LIBGL_ALWAYS_INDIRECT=1
    export LD_LIBRARY_PATH=/opt/wifiman:${lib.makeLibraryPath mesa-drivers}:${lib.makeSearchPathOutput "lib" "lib/vdpau" libvdpau}:${glxindirect}/lib:${lib.makeLibraryPath [libglvnd]}"''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    #export LD_LIBRARY_PATH="/opt/wifiman"
    export VK_ICD_FILENAMES=/opt/wifiman/vk_swiftshader_icd.json

    export GDB=${gdb}/bin/gdb 
    #/opt/wifiman/wifiman-desktop
    bash
  '';
  # meta = with lib; {
  #   homepage = "https://ui.com/download/app/wifiman-desktop";
  #   platforms = [ "x86_64-linux" ];
  # };
}

