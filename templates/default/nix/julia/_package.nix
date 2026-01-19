pkgs:
pkgs.julia.withPackages.override
    {
        augmentedRegistry = pkgs.callPackage ./_registry.nix { };
        precompile = false;
    }
    [
        "Pluto"
        "ArgParse"
        "LanguageServer"
        "JuliaFormatter"

        # Add your packages here

    ]
