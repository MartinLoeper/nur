{ lib, stdenv, pkgs, fetchFromGitHub, ... }:
pkgs.libratbag.overrideAttrs (old: {
  version = "1.5.6.pl02-patched";

  preInstall = ''
    substituteInPlace "xorriso-dd-target/xorriso-dd-target" \
      --replace "xdt_init ||" "xdt_lsblk_cmd=${pkgs.util-linux}/bin/lsblk;xdt_dd_cmd=${pkgs.coreutils}/bin/dd;xdt_umount_cmd=${pkgs.umount}/bin/umount ||"
  '';
})

