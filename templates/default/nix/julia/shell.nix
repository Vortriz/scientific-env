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
            julia = lib.getExe juliaEnv;
        in
        {
            devshells.julia = {
                devshell = {
                    name = "julia";
                    motd = "";
                    startup.default.text =
                        let
                            projectPath = "${juliaEnv.projectAndDepot.outPath}/project";
                        in
                        ''
                            rm -f Project.toml
                            ln -sf ${projectPath}/Project.toml $PRJ_ROOT/
                            rm -f Manifest.toml
                            ln -sf ${projectPath}/Manifest.toml $PRJ_ROOT/
                        '';
                };

                commands = [
                    {
                        name = "pluto";
                        category = "[julia]";
                        help = "Launch Pluto";
                        command = ''
                            ${julia} -e "import Pluto; Pluto.run()"
                        '';
                    }
                    {
                        name = "precompile";
                        category = "[julia]";
                        help = "Precompile Julia packages";
                        command = ''
                            ${julia} -e "import Pkg; Pkg.precompile()"
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
                        value = julia;
                    }
                ];

                packages = [
                    juliaEnv
                    pkgs.nix-prefetch-git
                    (pkgs.writeScriptBin "create" ''
                        if [ -z "$1" ]; then
                            ${julia} ${./create.jl} --help
                        else
                            ${julia} ${./create.jl} "$1"
                        fi
                    '')
                ];
            };
        };
}
