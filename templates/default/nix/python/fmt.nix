{
    perSystem =
        { pkgs, ... }:
        {
            treefmt = {
                programs = {
                    ruff-format.enable = true;
                    ruff-check = {
                        enable = true;
                        extendSelect = [ "I" ];
                    };
                };

                settings.formatter = {
                    ruff-format.priority = 1;
                    ruff-check = {
                        priority = 2;
                        options = [ "--fix-only" ];
                    };
                    marimo = {
                        priority = 3;
                        command = pkgs.lib.getExe pkgs.python3Packages.marimo;
                        options = [
                            "check"
                            "."
                            "--fix"
                            "--unsafe-fixes"
                            "--ignore-scripts"
                        ];
                        includes = [ "*.py" ];
                    };
                };
            };
        };
}
