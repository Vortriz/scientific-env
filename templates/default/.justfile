@repl:
    nix repl --expr \
    "let \
        flake = builtins.getFlake (toString ./.); \
        nixpkgs = import <nixpkgs> {}; \
    in \
        {inherit flake;} // flake // flake.lib // builtins // nixpkgs"
