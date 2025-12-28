{
    description = "Sane and reproducible scientific dev environments with Nix";

    inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    outputs =
        { nixpkgs, ... }:
        let
            inherit (nixpkgs) lib;

            forAllSystems =
                function: lib.genAttrs lib.systems.flakeExposed (system: function nixpkgs.legacyPackages.${system});
        in
        {
            templates = {
                default = {
                    description = "Opinionated flake";
                    path = ./templates/default;
                    welcomeText = ''
                        Welcome to the scientific dev environment!

                        Continue with the README for configuration guide.
                    '';
                };
            };

            formatter = forAllSystems (
                pkgs:
                pkgs.treefmt.withConfig {
                    runtimeInputs = [ pkgs.nixfmt ];
                    settings = {
                        formatter.nixfmt = {
                            command = "nixfmt";
                            includes = [ "*.nix" ];
                            options = [ "--indent=4" ];
                        };
                    };
                }
            );
        };
}
