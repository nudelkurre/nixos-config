{config, pkgs, lib, ...}:
with lib;
let
    my-python-packages = ps: with ps; [
        
    ];
in
{
    config = mkIf (config.disable.python != true) {
        home = {
            packages = with pkgs; [
                (python311.withPackages my-python-packages)
            ];
        };
    };
}