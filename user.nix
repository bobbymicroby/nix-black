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
    adoptopenjdk-hotspot-bin-11.0.1
    ;
  inherit (haskellPackages)
    ghcid
    hlint
    stylish-haskell
    ;

  ghc = pkgs.haskellPackages.ghcWithPackages (p: [  ]);

  vscode = import ./vscode { inherit pkgs; };
}
