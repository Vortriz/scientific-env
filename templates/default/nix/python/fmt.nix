{
    perSystem = {
        treefmt = {
            programs = {
                ruff-format.enable = true;
                ruff-check.enable = true;
            };

            settings.formatter = {
                ruff-format.priority = 1;
                ruff-check = {
                    priority = 2;
                    options = [ "--fix-only" ];
                };
                # [MARK] wait for https://github.com/NixOS/nixpkgs/pull/443053 to go through
                # marimo = {
                #     priority = 3;
                #     command = pkgs.lib.getExe pkgs.uv;
                #     options = [
                #         "run"
                #         "marimo"
                #         "check"
                #         "."
                #         "--fix"
                #         "--unsafe-fixes"
                #         "--ignore-scripts"
                #     ];
                #     includes = [ "*.py" ];
                # };
            };
        };
    };
}
