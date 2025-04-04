{pkgs, config, ...}:
{
    programs.ssh = {
        enable = ! config.disable.ssh;
        matchBlocks = {
            "router" = {
                hostname = "172.16.0.1";
                port = 22;
                user = "root";
            };
            "server" = {
                hostname = "172.16.0.12";
                port = 22;
                user = "emil";
            };
        };
    };
}