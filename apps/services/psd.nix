{ ... }:
{
    services.psd = {
        backupLimit = 5;
        browsers = [
            "chromium"
            "firefox"
        ];
        enable = true;
        resyncTimer = "1h";
        useBackup = true;
    };
}
