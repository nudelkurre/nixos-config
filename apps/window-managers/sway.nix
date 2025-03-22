{pkgs, config, lib, ...}:
let
    mod1 = "Mod4";
    mod2 = "Ctrl";
    mod3 = "Mod1";
    mod4 = "Shift";

    ws1 = "1";
    ws2 = "2";
    ws3 = "3";
    ws4 = "4";
    ws5 = "5";
    ws6 = "6";
    ws7 = "7";
    ws8 = "8";
    ws9 = "9";
    ws0 = "10";

    wsf = lib.lists.flatten (builtins.map (w:
        builtins.map (p:
            let
                wsfocus = (if p.focus then "for_window [app_id=\"${p.name}\"] focus\nfor_window [class=\"${p.name}\"] focus\n" else "");
            in
            "${wsfocus}"
        )(w.programs)
    )(config.workspaces));
in
{
    wayland.windowManager.sway = {
        config = {
            assigns = (
                builtins.listToAttrs (builtins.map (w:
                {
                    name = w.name;
                    value = lib.lists.flatten (map (p: [
                        {app_id = p.name;}
                        {class = p.name;}
                    ])
                    (w.programs));
                })
                (config.workspaces))
            );
            bars = [

            ];
            bindkeysToCode = false;
            colors = {
                focused = {
                    background = "#285577";
                    border = "#33ccff";
                    childBorder = "#33ccff";
                    indicator = "#993399";
                    text = "#ffffff";
                };
            };
            floating = {
                criteria = [
                    {app_id = "zenity";}
                    {window_role = "pop-up";}
                    {window_role = "task_dialog";}
                ];
                modifier = "${mod1}";
                titlebar = false;
            };
            focus = {
                followMouse = "yes";
                newWindow = "none";
            };
            fonts = {};
            gaps = {
                inner = 5;
                outer = -5;
                smartBorders = "on";
                smartGaps = true;
            };
            input = {
                "1003:34842:Atmel_Atmel_maXTouch_Digitizer" = {
                    events = "disabled";
                };
                "1133:16388:Logitech_K360" = {
                    xkb_layout = "se(nodeadkeys)";
                    xkb_numlock = "enable";
                };
                "2:14:ETPS/2_Elantech_Touchpad" = {
                    accel_profile = "flat";
                    events = "disabled_on_external_mouse";
                    pointer_accel = "0.5";
                    scroll_factor = "0.3";
                    scroll_method = "two_finger";
                    tap = "enable";
                };
                "type:keyboard" = {
                    xkb_layout = "se(nodeadkeys)";
                };
            };
            keybindings = {
                # start a terminal
                "${mod1}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";

                # Lock screen
                "${mod1}+l" = "exec swaylock";

                # Shutdown
                "${mod1}+${mod4}+s" = "exec systemctl poweroff";

                # Reboot
                "${mod1}+${mod2}+${mod4}+r" = "exec systemctl reboot";

                # kill focused window
                "${mod3}+F4" = "kill";

                # Resize mode
                "${mod1}+r" = "mode \"resize\"";

                # start dmenu (a program launcher)
                "${mod1}+d" = "exec rofi -show";

                # change focus
                "${mod3}+Tab" = "focus right";
                "${mod3}+${mod4}+Tab" = "focus left";

                # alternatively, you can use the cursor keys:
                "${mod1}+Left" = "focus left";
                "${mod1}+Down" = "focus down";
                "${mod1}+Up" = "focus up";
                "${mod1}+Right" = "focus right";

                # move focused window
                "${mod1}+${mod4}+Left" = "move left";
                "${mod1}+${mod4}+Down" = "move down";
                "${mod1}+${mod4}+Up" = "move up";
                "${mod1}+${mod4}+Right" = "move right";

                # split in horizontal orientation
                "${mod1}+h" = "split h";

                # split in vertical orientation
                "${mod1}+v" = "split v";

                # enter fullscreen mode for the focused container
                "${mod1}+f" = "fullscreen toggle";

                # toggle tiling / floating
                "${mod1}+${mod4}+space" = "floating toggle";

                # change focus between tiling / floating windows
                "${mod1}+space" = "focus mode_toggle";

                # focus the parent container
                "${mod1}+a" = "focus parent";

                # switch to workspace
                "${mod1}+1" = "workspace ${ws1}";
                "${mod1}+2" = "workspace ${ws2}";
                "${mod1}+3" = "workspace ${ws3}";
                "${mod1}+4" = "workspace ${ws4}";
                "${mod1}+5" = "workspace ${ws5}";
                "${mod1}+6" = "workspace ${ws6}";
                "${mod1}+7" = "workspace ${ws7}";
                "${mod1}+8" = "workspace ${ws8}";
                "${mod1}+9" = "workspace ${ws9}";
                "${mod1}+0" = "workspace ${ws0}";

                # move focused container to workspace
                "${mod1}+${mod4}+1" = "move container to workspace ${ws1}";
                "${mod1}+${mod4}+2" = "move container to workspace ${ws2}";
                "${mod1}+${mod4}+3" = "move container to workspace ${ws3}";
                "${mod1}+${mod4}+4" = "move container to workspace ${ws4}";
                "${mod1}+${mod4}+5" = "move container to workspace ${ws5}";
                "${mod1}+${mod4}+6" = "move container to workspace ${ws6}";
                "${mod1}+${mod4}+7" = "move container to workspace ${ws7}";
                "${mod1}+${mod4}+8" = "move container to workspace ${ws8}";
                "${mod1}+${mod4}+9" = "move container to workspace ${ws9}";
                "${mod1}+${mod4}+0" = "move container to workspace ${ws0}";

                # reload the configuration file
                "${mod1}+${mod4}+r" = "reload";
                # exit sway (logs you out of your X session)
                "${mod1}+${mod4}+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

                # Controlling media
                "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -i firefox,floorp play-pause";
                "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -i firefox,floorp next";
                "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -i firefox,floorp previous";

                # Change volume
                "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
                "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

                # Start Floorp
                "${mod1}+${mod4}+f" = "exec floorp";

                # Start Floorp in private window
                "${mod1}+${mod2}+${mod4}+f" = "exec floorp --private-window";

                # Take a screenshot
                "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";

                # Start jellyfin media player
                "${mod1}+kp_0" = "exec flatpak run com.github.iwalton3.jellyfin-media-player";

                # Start FreeTube
                "${mod1}+kp_1" = "exec freetube";

                # Open file browser
                "${mod1}+kp_2" = "exec nemo";

                # Open Steam
                "${mod1}+kp_5" = "exec steam --no-minimize-to-tray";
            };
            modes = {
                resize = {
                    Down = "resize grow height 10 px or 10 ppt";
                    Left = "resize shrink width 10 px or 10 ppt";
                    Right = "resize grow width 10 px or 10 ppt";
                    Up = "resize shrink height 10 px or 10 ppt";

                    # back to normal: Enter or Escape
                    Escape = "mode \"default\"";
                    Return = "mode \"default\"";
                };
            };
            output = (
                builtins.listToAttrs (builtins.map (m: 
                let
                    background = "${m.background} ${m.bg_style}";
                    position = "${toString m.x} ${toString m.y}";
                    resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz";
                in
                {
                    name = m.name;
                    value = {
                        adaptive_sync = m.adaptive_sync;
                        bg = background;
                        pos = position;
                        resolution = resolution;
                        transform = "${toString m.transform}";
                    };
                })
                (config.monitors.outputs))
            );
            seat = {
                "seat0" = {
                    xcursor_theme = "${config.gtk.cursorTheme.name} " + toString config.gtk.cursorTheme.size;
                };
            };
            startup = lib.lists.flatten [
                { command = "${pkgs.udiskie}/bin/udiskie -a";}
                { command = "dunst -conf ~/.config/dunst/dunstrc";}
                { command = "systemctl --user import-environment PATH";}
                (if config.monitors.primary != "" then [
                    {command = "${pkgs.xorg.xrandr}/bin/xrandr --output ${config.monitors.primary} --primary";}
                ] else [])
            ];
            window = {
                border = 1;
                hideEdgeBorders = "none";
                titlebar = false;
            };
            workspaceAutoBackAndForth = false;
            workspaceLayout = "default";
            workspaceOutputAssign = lib.lists.flatten (map 
                (m:
                    map (w:
                        {
                            output = m.name;
                            workspace = w;
                        }
                    )(m.workspaces)
                )(config.monitors.outputs)
            );
        };
        enable = ! config.disable.sway;
        extraConfig = ''
            ${lib.strings.concatStringsSep "" wsf}
            for_window [app_id="firefox"] opacity 1.0
            for_window [class="steam"] move to workspace ${ws5}
        '';
        extraSessionCommands = ''
            export XDG_SESSION_DESKTOP=sway
            export NIXOS_OZONE_WL=1
        '';
        systemd = {
            enable = true;
        };
        wrapperFeatures = {
            base = true;
            gtk = true;
        };
    };
}