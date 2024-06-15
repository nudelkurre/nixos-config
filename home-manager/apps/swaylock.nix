{pkgs, config, ...}:
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font = "${config.fonts.name}";
      font-size = "${toString config.fonts.size}";
    };
  };
}