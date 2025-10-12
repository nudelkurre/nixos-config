{ sharedSettings, ... }:
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
                hostname = "${sharedSettings.serverIP}";
                port = 22;
                user = "emil";
            };
        };
    };
}
