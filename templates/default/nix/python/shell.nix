{
    perSystem =
        { pkgs, ... }:
        let
            pythonPkg = pkgs.python313;
        in
        {
            devshells.python = {
                devshell = {
                    name = "python";
                    motd = "";
                    startup.default.text = "unset PYTHONPATH";
                };

                packages = [
                    pythonPkg
                ]
                ++ (with pkgs; [
                    uv
                    ruff
                ]);

                env = [
                    {
                        # Prevent uv from managing Python downloads
                        name = "UV_PYTHON_DOWNLOADS";
                        value = "never";
                    }
                    {
                        # Force uv to use nixpkgs Python interpreter
                        name = "UV_PYTHON";
                        value = pythonPkg.interpreter;
                    }
                    {
                        # Python libraries often load native shared objects using dlopen(3).
                        # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
                        # We use manylinux2014 which is compatible with 3.7.8+, 3.8.4+, 3.9.0+
                        name = "LD_LIBRARY_PATH";
                        prefix = pkgs.lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux2014;
                    }
                ];

                commands = [
                    {
                        name = "setup";
                        help = "Setup uv and marimo";
                        category = "[python]";
                        command = ''
                            uv init --bare
                            uv add marimo python-lsp-server websockets nbformat
                            ln -sr ${./.marimo.toml} $PRJ_ROOT/.marimo.toml
                        '';
                    }
                ];
            };
        };
}
