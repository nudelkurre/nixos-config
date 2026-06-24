{ ... }:
{
    programs = {
        git = {
            enable = true;
            lfs = {
                enable = true;
            };
            settings = {
                alias = {
                    st = "status";
                };
                user = {
                    email = "nudelkurre@protonmail.com";
                    name = "Emil Wendin";
                };
            };
        };
        git-cliff = {
            enable = true;
            settings = {
                changelogs = {
                    trim = true;
                    render_always = true;
                };
                git = {
                    sort_commits = "oldest";
                    topo_order = true;
                    topo_order_commits = true;
                };
            };
        };
    };
}
