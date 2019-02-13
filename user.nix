with import <nixpkgs> { };

{
  inherit (pkgs)
    cabal-install
    cabal2nix
    nix-prefetch-git
    emacs
    unrar
    unzip
    veracrypt
    ;
  inherit (haskellPackages)
    ghcid
    hlint
    stylish-haskell
    ;

  ghc = pkgs.haskellPackages.ghcWithPackages (p: [  ]);

  vscode = import ./vscode { inherit pkgs; };
}
