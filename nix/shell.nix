{
  deadnix,
  gitlint,
  haskellPackages,
  pre-commit,
  reuse,
  shellcheck,
  shfmt,
  statix,
  yamllint,
}:

let
  haskellTools = with haskellPackages; [
    cabal-fmt
    cabal-install
    cabal2nix
    ghcid
    hlint
    nix-linter
    ormolu
    scan
    stan
    weeder
  ];

  nixTools = [
    deadnix.deadnix
    statix
  ];

  shellTools = [
    shellcheck
    shfmt
  ];
in

haskellPackages.shellFor {
  packages = _: with haskellPackages; [
    artificial-regex
  ];

  nativeBuildInputs = [
    gitlint
    pre-commit
    reuse
    yamllint
  ]
    ++ haskellTools
    ++ nixTools
    ++ shellTools
  ;

  shellHook = ''
    export PATH="$PWD/scripts:$PATH"
  '';
}
