{
    description = "scientific-env Flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        flake-utils.url = "github:numtide/flake-utils";

        devshell = {
            url = "github:numtide/devshell";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # For using python via uv2nix
        pyproject-nix = {
            url = "github:pyproject-nix/pyproject.nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        uv2nix = {
            url = "github:pyproject-nix/uv2nix";
            inputs.pyproject-nix.follows = "pyproject-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        pyproject-build-systems = {
            url = "github:pyproject-nix/build-system-pkgs";
            inputs.pyproject-nix.follows = "pyproject-nix";
            inputs.uv2nix.follows = "uv2nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        flake-utils,
        devshell,
        ...
    } @ inputs: let
        systems = ["x86_64-linux"];
    in
        flake-utils.lib.eachSystem systems (
            system: let
                pkgs = import nixpkgs {
                    inherit system;
                    overlays = [devshell.overlays.default];
                };

                lib =
                    nixpkgs.lib
                    // (import ./nix/lib.nix {
                        inherit (nixpkgs) lib;
                        inherit pkgs;
                    });

                cfg =
                    (lib.evalModules {
                        modules = [(import ./nix/module.nix {inherit lib pkgs inputs;})];
                    }).config;
            in {
                inherit cfg lib;

                formatter = pkgs.alejandra;

                devShells.default = pkgs.devshell.mkShell {
                    name = "scientific-dev";

                    # To collect all lang.*.package, lang.*.extraPackages and merge it with additionalPackages
                    packages =
                        lib.lists.filter (lib.isDerivation) (lib.getLangAttr cfg "package")
                        ++ lib.lists.flatten (lib.getLangAttr cfg "extraPackages")
                        ++ cfg.additionalPackages;

                    # To collect all lang.*.env and merge it with cfg.env
                    env = lib.attrsets.attrsToList (
                        lib.mergeAttrsList (lib.getLangAttr cfg "env")
                        // cfg.env
                    );

                    devshell = {
                        # To collect all lang.*.shellHook and merge it with cfg.shellHook
                        startup.default.text = lib.strings.concatLines (
                            lib.getLangAttr cfg "shellHook"
                            ++ [cfg.shellHook]
                        );

                        motd = ''

                            {bold}Welcome to the scientific development environment!{bold}
                        '';
                    };
                };
            }
        );
}
