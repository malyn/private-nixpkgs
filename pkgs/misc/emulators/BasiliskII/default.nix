{ stdenv, fetchgit, autoconf, automake, gcc44, gtk, libX11,
  pkgconfig, SDL }:

stdenv.mkDerivation {
  name = "BasiliskII-1.0rc1-git";

  src = fetchgit {
    url = https://github.com/cebix/macemu.git;
    rev = "c2b519ee1ea848ac827e68cd1d536b3464b79ed1";
    sha256 = "1zjwrdqsnq5n78dsx6pd4j7d5m1c1lvhbpz2wkb3549fj28wajxd";
  };

  # Have to use gcc44 in order to avoid a known BasiliskII+SDL
  # segfault.
  buildInputs =
    [ autoconf automake gcc44 gtk libX11 pkgconfig SDL ];

  patches = [ ./fix-include-paths.diff ];

  preConfigure =
    ''
      cd BasiliskII/src/Unix \
        && aclocal -I `aclocal --print-ac-dir` -I m4 \
        && autoheader \
        && autoconf
    '';

  configureFlags =
    [ "--enable-sdl-audio"
      "--enable-sdl-video" ];

  meta = with stdenv.lib; {
    homepage = http://basilisk.cebix.net/;
    description = "Open source classic Mac OS (68k) emulator";
    longDescription =
      ''
        A MacOS run-time environment and 68k emulator.  You need a copy
        of MacOS and a Macintosh ROM image to use Basilisk II.
      '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ malyn ];
    platforms = platforms.linux;
  };
}
