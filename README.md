# Regex fun
Given a path of a file, where each line is syntactical subset of regex, as the
first command-line argument; transforms each regex to the number of strings
matched by that regex, the regex itself, and the simplified version of the regex
as a 3-tuple and return them as a list sorted by the first element of the tuple
in ascending order.

## building
### using Nix
```shell
nix build
```
or
```shell
nix-build ./nix/compat/default.nix
```

### using Cabal
```shell
cabal build
```

## testing
```shell
cabal test
```

## development environment
Nix flake provides a development shell that includes the Haskell dependencies,
linters and other tools. To enter:
### automatically, with direnv
allow the contents of `.envrc`
```
direnv allow .
```
### manually
```shell
nix develop
```
or
```shell
nix-shell ./nix/compat/default.nix
```

## scripts
There are two scripts included:
- `run_cabal2nix` to update the Nix files generated with `cabal2nix`
- `check` that will build and test the code and run linters/formatters

`./scripts` directory is automatically added to `PATH` inside the development
environment.
