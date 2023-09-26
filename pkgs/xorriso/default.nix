{ lib, stdenv, pkgs, fetchurl, ... }:
pkgs.xorriso.overrideAttrs (old: {
  version = "${old.version}-patched";

  src = fetchurl {
    url = "https://www.gnu.org/software/xorriso/xorriso-${old.version}.tar.gz";
    sha256 = "sha256-hnV3w4f2tKmjIk60Qd7Y+xY432y8Bg+NGh5dAPMY9QI=";
  };

  preInstall = ''
    substituteInPlace "xorriso-dd-target/xorriso-dd-target" \
      --replace "xdt_init ||" "xdt_lsblk_cmd=${pkgs.util-linux}/bin/lsblk;xdt_dd_cmd=${pkgs.coreutils}/bin/dd;xdt_umount_cmd=${pkgs.umount}/bin/umount ||"
  '';
})

