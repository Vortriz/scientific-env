{
    perSystem = {
        treefmt = {
            programs = {
                typstyle.enable = true;
            };

            settings.formatter = {
                typstyle = {
                    priority = 1;
                    options = [
                        "--indent-width"
                        "4"
                    ];
                };
            };
        };
    };
}
