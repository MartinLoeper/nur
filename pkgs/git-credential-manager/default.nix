{ lib
, stdenv
, fetchFromGitHub
, buildDotnetModule
, dotnet-sdk_7
, xorg
, libICE
, libSM
, fontconfig
, libsecret
, git
, git-credential-manager
, mkShell
, makeSetupHook
, bash
, writeScript
, which
}:

buildDotnetModule rec {
  pname = "git-credential-manager";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "git-ecosystem";
    repo = "git-credential-manager";
    rev = "d6035ef7f8e6916816949cad9dfcc0b1cfdab808";
    hash = "sha256-XXtir/sSjJ1rpv3UQHM3Kano/fMBch/sm8ZtYwGyFyQ=";
  };

  executables = [];

  patches = [
    ./0001-enable-app-host-property.patch
    ./0002-skip-install-and-pack.patch
    ./0003-enable-deterministic-publish.patch
  ];

  NO_INSTALL_OR_PACK = 1;

  dontDotnetInstall = 1;

  customInstallHook = makeSetupHook {
    name = "dotnet-install-hook";
    substitutions = { shell = "${bash}/bin/bash"; };
    meta.platforms = lib.platforms.linux;
  } (writeScript "install.sh" ''
      #!@shell@

      customInstallHook() {
        mkdir -p "$out/lib"
        mv "./out/linux/Packaging.Linux/LinuxRelease/payload/"* "$out/lib/"
      }

      if [[ -z "''${installPhase-}" ]]; then
          installPhase=customInstallHook
      fi
  '');

  nativeBuildInputs = [
    customInstallHook
    which
  ];

  projectFile = [
    "./src/linux/Packaging.Linux/Packaging.Linux.csproj"
  ];

  preConfigure = ''
    echo "Patching shebang for $src/src/linux/Packaging.Linux/"*.sh
    patchShebangs "./src/linux/Packaging.Linux/"*.sh

    echo "Removing nuget.config from sources..."
    rm "./nuget.config"
  '';

  # This deps.nix can be generated by running
  #     nix-build -A git-credential-manager.passthru.fetch-deps | bash
  # and copying the resulting file to 'deps.nix'
  # note: you have to create an empty deps.nix before running the command above
  nugetDeps = ./deps.nix;

  runtimeDeps = [
    # Avalonia dependencies
    xorg.libX11
    libICE
    libSM
    fontconfig

    # GCM native dependencies
    libsecret
  ];

  dotnet-sdk = dotnet-sdk_7;
  buildType = "LinuxRelease";

  meta = with lib; {
    homepage = "https://github.com/git-ecosystem/git-credential-manager";
    description = "Secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services";
    longDescription = ''
      Git Credential Manager (GCM) is a secure Git credential helper built on .NET that runs on Windows, macOS, and Linux. It aims to provide a consistent and secure authentication experience, including multi-factor auth, to every major source control hosting service and platform.
      GCM supports (in alphabetical order) Azure DevOps, Azure DevOps Server (formerly Team Foundation Server), Bitbucket, GitHub, and GitLab. Compare to Git's built-in credential helpers (Windows: wincred, macOS: osxkeychain, Linux: gnome-keyring/libsecret), which provide single-factor authentication support for username/password only.
      GCM replaces both the .NET Framework-based Git Credential Manager for Windows and the Java-based Git Credential Manager for Mac and Linux.
    '';
    license = licenses.mit;
    changelog = "https://github.com/git-ecosystem/git-credential-manager/releases/tag/v${version}";
    platforms = with platforms; linux ++ darwin ++ windows;
    mainProgram = "git-credential-manager";
  };

  passthru.tests = {
    diagnose = mkShell {
      packages = [ git-credential-manager git ];
      shellHook = ''
        ${git-credential-manager}/bin/git-credential-manager diagnose
        if [ $? -eq 0 ]; then
          exit 1;
        fi
        touch $out
      '';
    };

    version = mkShell {
      packages = [ git-credential-manager git ];
      shellHook = ''
        mkdir -p $out
        ${git-credential-manager}/bin/git-credential-manager --version > $out/version
        grep -Fxq "${version}" $out/version
      '';
    };
  };
}