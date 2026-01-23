pkgs:
pkgs.julia.withPackages.override
    {
        augmentedRegistry = pkgs.callPackage ./_registry.nix { };
    }
    [
        "Pluto"
        "ArgParse"
        "LanguageServer"
        "JuliaFormatter"

        # Add your packages here

    ]
