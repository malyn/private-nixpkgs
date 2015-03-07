{ stdenv, fetchgit, autoconf, automake, file, gcc44, gtk, libX11, perl,
  pkgconfig, SDL }:

stdenv.mkDerivation {
  name = "SheepShaver-2.3-git";

  src = fetchgit {
    url = https://github.com/cebix/macemu.git;
    rev = "c2b519ee1ea848ac827e68cd1d536b3464b79ed1";
    sha256 = "1zjwrdqsnq5n78dsx6pd4j7d5m1c1lvhbpz2wkb3549fj28wajxd";
  };

  # Have to use gcc44 in order to avoid a known SheepShaver+SDL
  # segfault.
  buildInputs =
    [ autoconf automake file gcc44 gtk libX11 perl pkgconfig SDL ];

  patches = [ ./fix-include-paths.diff ];

  preConfigure =
    ''
      substituteInPlace SheepShaver/src/Unix/configure.ac \
        --replace "/usr/bin/file" "${file}/bin/file"
      cd SheepShaver/src/Unix \
        && aclocal -I `aclocal --print-ac-dir` -I m4 \
        && autoheader \
        && autoconf
    '';

  configureFlags =
    [ "--enable-sdl-audio"
      "--enable-sdl-video" ];

  meta = with stdenv.lib; {
    homepage = http://sheepshaver.cebix.net/;
    description = "Open source PowerMac (classic MacOS) emulator";
    longDescription =
      ''
        A MacOS run-time environment and PowerPC emulator for BeOS and
        Linux that allows you to run classic MacOS applications inside
        the BeOS/Linux multitasking environment.  You need a copy of
        MacOS and a PowerMac ROM image to use SheepShaver.
      '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ malyn ];
    platforms = platforms.linux;
  };
}
