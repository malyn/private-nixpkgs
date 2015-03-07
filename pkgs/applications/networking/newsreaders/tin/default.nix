{ stdenv, fetchurl, bison, ncurses, pcre,
  gpgSupport ? false,
  gnupg1compat ? null}:

assert gpgSupport -> gnupg1compat != null;

stdenv.mkDerivation {
  name = "tin-2.2.1";

  src = fetchurl {
    url = ftp://ftp.tin.org/pub/news/clients/tin/v2.2/tin-2.2.1.tar.gz;
    sha256 = "1b2nwk0fi40w019mxj7l8finq6rav19iwc87p2c18wg4pf28hn6g";
  };

  buildInputs =
    [ bison ncurses pcre ]
    ++ stdenv.lib.optional gpgSupport gnupg1compat;

  configureFlags =
    [ "--with-curses-dir=${ncurses}"
      "--with-ncurses"
      "--with-pcre=${pcre}"
      "--enable-ipv6" ]
    ++ stdenv.lib.optional gpgSupport "--with-gpg=${gnupg1compat}/bin/gpg";

  buildFlags = "build";

  meta = with stdenv.lib; {
    homepage = http://tin.org/;
    description = "Easy-to-use USENET news reader";
    longDescription =
      ''
        An easy-to-use USENET news reader for the console using NNTP.
        It supports threading, scoring, different charsets, and many other
        useful things. It has also support for different languages.
      '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ malyn ];
    platforms = platforms.linux;
    priority = 10; # Provides mbox.5, which clashes with mail clients.
  };
}
