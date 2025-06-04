{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) types;
in {
    types-custom = rec {
        envType = with types; attrsOf (oneOf [str int bool package]);

        langCfgType = types.submodule ({name, ...}: {
            options = {
                enable = lib.mkEnableOption "the language's availability in the environment.";

                package = lib.mkPackageOption pkgs name {
                    default = null;
                    nullable = true;
                };

                extraPackages = lib.mkOption {
                    type = with types; nullOr (listOf package);
                    default = [];
                    description = "Additional packages to be included in the language environment.";
                };

                env = lib.mkOption {
                    type = types.nullOr envType;
                    default = {};
                    description = "Environment variables to set for the language runtime.";
                };

                shellHook = lib.mkOption {
                    type = types.nullOr types.str;
                    default = "";
                    description = "Shell hook to run when the language environment is activated.";
                };
            };
        });
    };

    getLangAttr = cfg: attr: lib.forEach (lib.attrsets.attrNames cfg) (l: cfg.${l}.${attr});
}
