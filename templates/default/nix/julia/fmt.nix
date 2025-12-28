{
    perSystem =
        { lib, pkgs, ... }:
        let
            juliaEnv = import ./_package.nix pkgs;
            julia = lib.getExe juliaEnv;
        in
        {
            treefmt = {
                settings.formatter = {
                    jlfmt = {
                        priority = 1;
                        command = julia;
                        options = [ "${./fmt.jl}" ];
                        includes = [ "*.jl" ];
                    };
                };
            };
        };
}
