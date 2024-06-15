{config, pkgs, ...}:
let
    my-python-packages = ps: with ps; [
        (
            
        )
    ];
in
{
    home.packages = with pkgs; [
        (python311.withPackages my-python-packages)
    ];
}