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
                    Continue with the README for configuration guide.
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

                    Continue with the README for configuration guide.
                '';
            };
        };

        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    };
}
