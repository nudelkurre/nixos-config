{
    programs.ssh = {
        enable = true;
        matchBlocks = {
            "server" = {
                hostname = "172.16.0.12";
                port = 22;
                user = "emil";
            };
            "router" = {
                hostname = "172.16.0.1";
                port = 22;
                user = "root";
            };
        };
    };
}