{ inputs, ... }:
{
    perSystem =
        {
            lib,
            pkgs,
            system,
            ...
        }:
        let
            juliaEnv = import ./_package.nix pkgs;
        in
        {
            devshells.julia = {
                devshell = {
                    name = "julia";
                };

                commands = [
                    {
                        name = "pluto";
                        category = "[julia]";
                        help = "Launch Pluto";
                        command = ''
                            ${juliaEnv}/bin/julia -e "import Pluto; Pluto.run()"
                        '';
                    }
                    {
                        name = "update-registry";
                        category = "[julia]";
                        help = "Update Julia package registry";
                        command = lib.getExe (
                            pkgs.writers.writePython3Bin "update-registry" {
                                libraries = [ inputs.nima.packages.${system}.default ];
                            } ./update-registry.py
                        );
                    }
                ];

                env = [
                    {
                        name = "JULIA_NUM_THREADS";
                        value = "auto";
                    }
                    {
                        name = "julia";
                        value = "${juliaEnv}/bin/julia";
                    }
                ];

                packages = [
                    juliaEnv
                    pkgs.nix-prefetch-git
                ];
            };
        };
}
