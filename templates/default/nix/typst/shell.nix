{
    perSystem =
        { pkgs, ... }:
        {
            devshells.typst = {
                devshell = {
                    name = "typst";
                    motd = "";
                };
                packages = [ pkgs.typst ];
            };
        };
}
