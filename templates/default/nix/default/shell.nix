{
    perSystem =
        { pkgs, ... }:
        {
            devshells.default = {
                devshell = {
                    name = "base";
                    motd = "";
                };

                packages = with pkgs; [
                    # Search for available packages on https://search.nixos.org/packages

                ];
            };
        };
}
