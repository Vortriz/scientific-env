{
    lib,
    pkgs,
    inputs,
    ...
}: let
    inherit (lib) types types-custom;

    cfg = import ../config.nix pkgs;
in rec {
    imports = [
        (import ./modules/julia {inherit lib pkgs config;})
        (import ./modules/python {inherit lib pkgs config inputs;})
    ];

    options = {
        shell = lib.mkPackageOption pkgs "bash" {};

        additionalPackages = lib.mkOption {
            type = with types; nullOr (listOf package);
            default = null;
            description = "Additional packages to be included in the environment.";
        };

        env = lib.mkOption {
            type = types.nullOr types-custom.envType;
            default = null;
            description = "Environment variables to be set in the shell.";
        };

        shellHook = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Shell hook to be executed when the default environment starts.";
        };
    };

    config = with lib; {
        shell = cfg.shell or options.shell.default;
        additionalPackages = cfg.additionalPackages or [];
        env = cfg.env or {};
        shellHook = cfg.shellHook or "";

        lang = {
            python = cfg.lang.python or {enable = mkDefault false;};
            julia = cfg.lang.julia or {enable = mkDefault false;};
        };
    };
}
