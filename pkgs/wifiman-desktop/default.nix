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
, wrapGAppsHook
, glib
, nspr
, pango
, xorg_sys_opengl
, libxkbcommon
, ffmpeg-full
}:

let
  version = "0.3.0";

  rpath = lib.makeLibraryPath [
    dpkg
    xorg.libXcomposite
    xorg.libX11
    xorg.libXdamage
    xorg_sys_opengl
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    libxkbcommon
    dbus
    at-spi2-atk
    cups
    nss
    cairo
    libdrm
    gtk3
    mesa
    alsaLib
    libglvnd
    glib
    nspr
    pango
    ffmpeg-full
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-${version}-linux-amd64.deb";
    sha256 = "sha256-ZGjTCewURJFJ3k8DaB5VxeaGJ9cnRh5x5j69ioyFgLM=";
  };

in
stdenv.mkDerivation {
  name = "wifiman-desktop-${version}";

  system = "x86_64-linux";

  inherit src;

  nativeBuildInputs = [
    wrapGAppsHook
    glib # For setup hook populating GSETTINGS_SCHEMA_PATH
  ];

  buildInputs = [ dpkg ];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    mkdir -p $out/bin
    dpkg -x $src $out
    cp -av "$out/opt/WiFiman Desktop"/* $out
    #mv $out/libffmpeg.so $out/libffmpeg
    rm -rf $out/opt $out/usr #$out/*.so*
    #mv $out/libffmpeg $out/libffmpeg.so

    ln -s /tmp $out/tmp
    #ln -s ${libglvnd}/lib/libGLESv2.so $out/libGLESv2.so
    #ln -s ${libglvnd}/lib/libEGL.so $out/libEGL.so

    # Otherwise it looks "suspicious"
    chmod -R g-w $out
  '';

  postFixup = ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out $file || true
    done

    ln -s "$out/wifiman-desktop" "$out/bin/wifiman-desktop"
  '';
}
