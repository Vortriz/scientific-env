{
    lib,
    pkgs,
    config,
    inputs,
    ...
}: let
    inherit (inputs) pyproject-nix uv2nix pyproject-build-systems;

    cfg = config.lang.python;
in {
    options = {
        lang.python = lib.mkOption {
            type = lib.types-custom.langCfgType;
        };
    };

    config = with lib;
        mkIf cfg.enable {
            lang.python = assert assertMsg (hasAttr "package" cfg) "`lang.python.package` must be specified and be a valid package when enabling Python environment."; let
                python = cfg.package;

                # Load a uv workspace from a workspace root.
                # Uv2nix treats all uv projects as workspace projects.
                workspace = uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ../../.;};

                # Create package overlay from workspace.
                overlay = workspace.mkPyprojectOverlay {
                    # Prefer prebuilt binary wheels as a package source.
                    # Sdists are less likely to "just work" because of the metadata missing from uv.lock.
                    # Binary wheels are more likely to, but may still require overrides for library dependencies.
                    sourcePreference = "wheel"; # or sourcePreference = "sdist";
                    # Optionally customise PEP 508 environment
                    # environ = {
                    #     platform_release = "5.10.65";
                    # };

                    # Extend generated overlay with build fixups
                    #
                    # Uv2nix can only work with what it has, and uv.lock is missing essential metadata to perform some builds.
                    # This is an additional overlay implementing build fixups.
                    # See:
                    # - https://pyproject-nix.github.io/uv2nix/FAQ.html
                    pyprojectOverrides = _final: _prev: {
                        # Implement build fixups here.
                        # Note that uv2nix is _not_ using Nixpkgs buildPythonPackage.
                        # It's using https://pyproject-nix.github.io/pyproject.nix/build.html
                    };

                    # Construct package set
                    pythonSet =
                        # Use base package set from pyproject.nix builders
                        (pkgs.callPackage pyproject-nix.build.packages {inherit python;}).overrideScope
                        (
                            lib.composeManyExtensions [
                                pyproject-build-systems.overlays.default
                                overlay
                                pyprojectOverrides
                            ]
                        );
                };
            in {
                extraPackages = [pkgs.uv];

                # [TODO] Requires more setup
                # Package a virtual environment as our main application.
                #
                # Enable no optional dependencies for production build.
                # packages.x86_64-linux.default = pythonSet.mkVirtualEnv builtins.toString ../../. workspace.deps.default;

                # Make hello runnable with `nix run`
                # apps.x86_64-linux = {
                #     default = {
                #         type = "app";
                #         program = "${self.packages.x86_64-linux.default}/bin/hello";
                #     };
                # };

                # This devShell simply adds Python and undoes the dependency leakage done by Nixpkgs Python infrastructure.
                env =
                    {
                        # Prevent uv from managing Python downloads
                        UV_PYTHON_DOWNLOADS = "never";
                        # Force uv to use nixpkgs Python interpreter
                        UV_PYTHON = python.interpreter;
                    }
                    // lib.optionalAttrs pkgs.stdenv.isLinux {
                        # Python libraries often load native shared objects using dlopen(3).
                        # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
                        LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
                    }
                    // cfg.env or {};

                shellHook =
                    ''
                        unset PYTHONPATH
                    ''
                    + cfg.shellHook or "";
            };
        };
}
