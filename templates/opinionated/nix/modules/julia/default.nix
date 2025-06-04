{
    lib,
    pkgs,
    config,
    ...
}: {
    options = {
        julia = lib.mkOption {
            type = lib.types-custom.langCfgType;
        };
    };

    config = with lib;
        if config.julia.enable or false
        then let
            cfg = config.julia;
        in {
            julia = assert assertMsg (hasAttr "package" cfg) "`julia.package` must be specified and be a valid package when enabling Julia environment."; {
                extraPackages = [pkgs.xwayland-satellite];

                env =
                    {
                        # For xwayland-satellite
                        DISPLAY = ":0";
                    }
                    // cfg.env or {};
            };
        }
        else {
            julia = {
                package = mkForce null;
                extraPackages = mkForce [];
                env = mkForce {};
                shellHook = mkForce "";
            };
        };
}
