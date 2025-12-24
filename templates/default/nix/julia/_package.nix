pkgs:
pkgs.julia.withPackages.override
    {
        augmentedRegistry = import ./_registry.nix { inherit (pkgs) fetchFromGitHub; };
    }
    [
        "Pluto"
        "LanguageServer"
        "JuliaFormatter"
    ]
