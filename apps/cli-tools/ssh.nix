{ ... }:
{
    programs.ssh = {
        enable = true;
        matchBlocks = {
            "router" = {
                hostname = "10.20.0.1";
                port = 22;
                user = "root";
            };
            "server" = {
                hostname = "10.10.0.12";
                port = 22;
                user = "emil";
            };
        };
    };
}
