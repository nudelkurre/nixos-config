{ sharedSettings, ... }:
{
    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
            "*" = {
                forwardAgent = false;
                addKeysToAgent = "no";
                compression = false;
                serverAliveInterval = 0;
                serverAliveCountMax = 3;
                hashKnownHosts = false;
                userKnownHostsFile = "~/.ssh/known_hosts";
                controlMaster = "no";
                controlPath = "~/.ssh/master-%r@%n:%p";
                controlPersist = "no";
            };
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
