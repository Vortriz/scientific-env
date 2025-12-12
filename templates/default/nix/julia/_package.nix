pkgs:
pkgs.julia.withPackages.override
    {
        augmentedRegistry = (pkgs.callPackage ./_sources/generated.nix { }).registry.src;
    }
    [
        "Pluto"
        "LanguageServer"
        "JuliaFormatter"
    ]
