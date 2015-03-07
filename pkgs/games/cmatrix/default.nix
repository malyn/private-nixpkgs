{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "cmatrix-1.2a";

  src = fetchurl {
    url = http://asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz;
    sha256 = "0k06fw2n8nzp1pcdynhajp5prba03gfgsbj91bknyjr5xb5fd9hz";
  };

  buildInputs = [ ncurses ];
}
