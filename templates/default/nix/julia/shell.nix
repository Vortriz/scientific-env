{
    perSystem =
        { pkgs, ... }:
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
                        package = pkgs.nvfetcher;
                        command = ''
                            nvfetcher -c ${./nvfetcher.toml} -o ${./_sources}
                        '';
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

                packages = [ juliaEnv ];
            };
        };
}
