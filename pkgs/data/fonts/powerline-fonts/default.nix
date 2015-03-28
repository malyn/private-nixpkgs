{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "powerline-fonts-39c99c";

  src = fetchgit {
    url = https://github.com/powerline/fonts.git;
    rev = "39c99c02652f25290b64e24a7e9a7cfb8ce89a3e";
    sha256 = "9c83a30f36dc980582c0a079bd2896f95d19e1cb0ba5afbd8cae936c944256dd";
  };

  buildPhase = "true";

  installPhase =
    ''
      mkdir -p $out/share/fonts/opentype
      cp -v */*.otf $out/share/fonts/opentype

      mkdir -p $out/share/fonts/truetype
      cp -v */*.ttf $out/share/fonts/truetype
    '';
}
