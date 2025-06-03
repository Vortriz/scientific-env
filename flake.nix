{
    description = "Sane and reproducible scientific dev environments with Nix";

    inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    outputs = {nixpkgs, ...}: let
        forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in {
        templates = {
            default = {
                description = ''
                    Default flake - Initialize, Configure and start working!
                '';
                path = ./templates/default;
                welcomeText = ''
                    `Welcome to the scientific dev environment!`
                    To get started, simply do the following:
                    1. Set up basic things and configure the language(s) you want to use in `config.nix`.
                    2. If you are using this on anything other than `x84_64-linux`, make sure to set it
                    in `flake.nix`, under outputs.
                    3. Thats it! You can now run `nix develop` to enter the environment.
                       (If you use `direnv`, then run `direnv allow`).

                    For more information, check out the project README.
                '';
            };

            opinionated = {
                description = ''
                    Opinionated flake - A more complete setup with additional tools and configurations.
                '';
                path = ./templates/opinionated;
                welcomeText = ''
                    Welcome to the scientific dev environment!

                    This is an opinionated version of the template with additional tools:
                    • marimo - A next-generation reactive, reproducible and git friendly notebook for python.
                               Homepage - https://marimo.io/
                    • typst - A new markup-based typesetting system that is powerful and easy to learn.
                               Homepage - https://typst.app/
                    • ruff - An extremely fast Python linter and code formatter, written in Rust.
                               Homepage - https://docs.astral.sh/ruff/

                    To get started, simply do the following:
                    1. Set up additional things and configure the language(s) you want to use in `config.nix`.
                    2. If you are using this on anything other than `x84_64-linux`, make sure to set it
                       in `flake.nix`, under outputs.
                    3. Thats it! You can now run `nix develop` to enter the environment.
                       (If you use `direnv`, then run `direnv allow`).
                '';
            };
        };

        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    };
}
