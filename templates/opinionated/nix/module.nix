{
    lib,
    pkgs,
    inputs,
    ...
}: rec {
    imports = [
        (import ./modules/julia {inherit lib pkgs config;})
        (import ./modules/python {inherit lib pkgs config inputs;})
    ];

    options = {
        default = lib.mkOption {
            type = lib.types-custom.langCfgType;
        };
    };

    config = with lib; let
        cfg = import ../config.nix pkgs;
    in
        if cfg.default.enable or false
        then cfg
        else {
            default = {
                package = mkForce null;
                extraPackages = mkForce [];
                env = mkForce {};
                shellHook = mkForce "";
            };
        };
}
