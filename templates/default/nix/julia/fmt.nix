{
    perSystem =
        { pkgs, ... }:
        let
            juliaEnv = import ./_package.nix pkgs;
        in
        {
            treefmt = {
                settings.formatter = {
                    jlfmt = {
                        priority = 1;
                        command = "${juliaEnv}/bin/julia";
                        options = [ "${./fmt.jl}" ];
                        includes = [ "*.jl" ];
                    };
                };
            };
        };
}
