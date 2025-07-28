{pkgs, config, ...}:
{
    programs.bat = {
        config = {
            style = "numbers,rule";
            theme = "Catppuccin Frappe";
        };
        enable = ! config.disable.bat;
        themes = {
            catppuccin = {
                src = pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "bat";
                    rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
                    hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
                };
            };
        };
    };
}