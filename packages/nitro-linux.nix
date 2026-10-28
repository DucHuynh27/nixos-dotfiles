{
  pkgs,
  lib,
  nitroSrc,
  nvidiaPackage ? null,
}: let
  nvidiaSmiCompat =
    if nvidiaPackage != null
    then
      pkgs.writeShellScriptBin "nvidia-smi" ''
        export LD_LIBRARY_PATH=${lib.getLib nvidiaPackage}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
        exec ${lib.getBin nvidiaPackage}/origBin/nvidia-smi "$@"
      ''
    else null;
in
  pkgs.stdenv.mkDerivation {
    pname = "nitro-linux";
    version = "2.3.1";
    src = nitroSrc;
    dontBuild = true;
    nativeBuildInputs = [pkgs.python3];
    installPhase = ''
      mkdir -p $out/bin $out/tools
      install -Dm755 tools/nitro.py $out/bin/nitro
      install -Dm755 tui/nitro-linux.py $out/bin/nitro-linux
      install -Dm755 daemon/nitrod.py $out/bin/nitrod
      install -Dm755 deploy/nitro-apply $out/bin/nitro-apply
      install -Dm644 tools/model.py $out/tools/model.py
      install -Dm644 VERSION $out/VERSION
      patchShebangs $out/bin
      ${lib.optionalString (nvidiaSmiCompat != null) ''
        substituteInPlace $out/bin/nitrod $out/bin/nitro-linux \
          --replace-fail '"nvidia-smi"' '"${nvidiaSmiCompat}/bin/nvidia-smi"'
      ''}
    '';
    meta.mainProgram = "nitro";
  }
