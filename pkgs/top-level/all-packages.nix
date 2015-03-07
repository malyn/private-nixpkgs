# See <http://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html>
# for information on this approach.
#
# Note that a critical feature of this approach is that these private
# packages can depend on each other.  In the current case, `hollywood`
# can depend on `cmatrix`.  (which is why we extend `callPackage` to
# include `self`, again, per the above blog post).
#
# I have also merged my own approach based on nixpkgs into this file.
# You add a link to this repo to your ~/.nix-defexpr and can then refer
# to these packages through that (namespaced) link.  For example, if the
# link is called "mypkgs" then you can `nix-env -iA mypkgs.whatever`
# where "whatever" is one of the packages that is defined here.
#
# Note that you also need to add `mypkgs=...` to NIX_PATH in order to
# use the `nix-env -f ~/.config/packages.nix -ir` approach for
# declaratively managing the list of user-level packages.
{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  self = rec {
    cmatrix = callPackage ../games/cmatrix { };
    hollywood = callPackage ../games/hollywood { };
    realvnc = callPackage ../applications/networking/remote/realvnc { };
    SheepShaver = callPackage ../misc/emulators/SheepShaver { };
    tin = callPackage ../applications/networking/newsreaders/tin { };
  };
in
self
