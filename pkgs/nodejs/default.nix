{ nodejs, fetchurl, ... }:

nodejs.overrideAttrs
  (upstream:
  let
    version = "20.11.1";
    hash = "sha256-d4E+2/P38W0tNdM1NEPe5OYdXuhNnjE4x1OKPAylIJ4=";
  in
  {
    inherit version;
    src = fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      inherit hash;
    };
    enableNpm = true;
  }
  )
