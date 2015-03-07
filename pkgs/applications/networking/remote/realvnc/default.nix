{ stdenv, requireFile, gzip, libX11, libXext }:

stdenv.mkDerivation {
  name = "realvnc-5.2.2";

  # FIXME: Needs to choose between the two binaries based on the
  # architecture.
  src = requireFile {
    message = ''
      Please download RealVNC Viewer for Linux x64 and then use
      nix-prefetch-url file:///path/to/VNC-Viewer-5.2.2-Linux-x64.gz
    '';
    #url = http://www.realvnc.com/download/binary/1676/;
    name = "VNC-Viewer-5.2.2-Linux-x64.gz";
    sha256 = "1mh4f59yb215mx956681wbijzp8qj6bkx092zmg78ka98q5j7wpb";
  };

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ gzip ];

  unpackPhase = ''
    mkdir -p $out/bin
    gunzip --to-stdout $src > $out/bin/vncviewer
    chmod +x $out/bin/vncviewer
  '';

  libPath = stdenv.lib.makeLibraryPath [ libX11 libXext ];

  # FIXME: Needs to choose between the two interpreters per example in
  # pkgs/tools/graphics/pngout/default.nix
  installPhase = ''
    patchelf \
      --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
      --set-rpath "$libPath" \
        "$out/bin/vncviewer"
  '';
}
