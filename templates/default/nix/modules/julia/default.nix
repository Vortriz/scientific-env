{
    lib,
    pkgs,
    config,
    ...
}: let
    cfg = config.lang.julia;
in {
    options = {
        lang.julia = lib.mkOption {
            type = lib.types-custom.langCfgType;
        };
    };

    config = with lib;
        mkIf cfg.enable {
            lang.julia = assert assertMsg (hasAttr "package" cfg) "`lang.julia.package` must be specified and be a valid package when enabling Julia environment."; {
                extraPackages = [pkgs.xwayland-satellite];

                env =
                    {
                        # For xwayland-satellite
                        DISPLAY = ":0";
                    }
                    // cfg.env or {};
            };
        };
}
