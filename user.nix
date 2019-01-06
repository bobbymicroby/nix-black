with import <nixpkgs> { };

{
  inherit (pkgs)
    cabal-install
    cabal2nix
    emacs
    unrar
    unzip
    ;
  inherit (haskellPackages)
    ghcid
    hlint
    stylish-haskell
    ;

  ghc = pkgs.haskellPackages.ghcWithPackages (p: [  ]);

  vscode = import ./vscode { inherit pkgs; };
}