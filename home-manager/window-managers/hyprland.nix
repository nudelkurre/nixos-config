{pkgs, config, lib, ...}:
{
    wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;
        systemd.enable = true;
        plugins = [
            pkgs.hyprlandPlugins.hy3
        ];
        settings = {
            "$mod1" = "SUPER";
            "$mod2" = "CTRL";
            "$mod3" = "ALT";
            "$mod4" = "SHIFT";

            bind = [
                "$mod1, RETURN, exec, kitty"
                "$mod3, F4, killactive"
                "$mod1 $mod4, E, exit"
                "$mod1 $mod4, SPACE, togglefloating"
                "$mod1, F, fullscreen"
                "$mod1, J, togglesplit"
                "$mod1, J, layoutmsg, orientationcycle left top"
                "$mod1, D, exec, rofi -show"

                # Move focus with mainMod + arrow keys
                "$mod1, left, movefocus, l"
                "$mod1, right, movefocus, r"
                "$mod1, up, movefocus, u"
                "$mod1, down, movefocus, d"

                # Switch workspaces with mainMod + [0-9]
                "$mod1, 1, workspace, 1"
                "$mod1, 2, workspace, 2"
                "$mod1, 3, workspace, 3"
                "$mod1, 4, workspace, 4"
                "$mod1, 5, workspace, 5"
                "$mod1, 6, workspace, 6"
                "$mod1, 7, workspace, 7"
                "$mod1, 8, workspace, 8"
                "$mod1, 9, workspace, 9"
                "$mod1, 0, workspace, 10"

                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mod1 $mod4, 1, movetoworkspacesilent, 1"
                "$mod1 $mod4, 2, movetoworkspacesilent, 2"
                "$mod1 $mod4, 3, movetoworkspacesilent, 3"
                "$mod1 $mod4, 4, movetoworkspacesilent, 4"
                "$mod1 $mod4, 5, movetoworkspacesilent, 5"
                "$mod1 $mod4, 6, movetoworkspacesilent, 6"
                "$mod1 $mod4, 7, movetoworkspacesilent, 7"
                "$mod1 $mod4, 8, movetoworkspacesilent, 8"
                "$mod1 $mod4, 9, movetoworkspacesilent, 9"
                "$mod1 $mod4, 0, movetoworkspacesilent, 10"

                # Scroll through existing workspaces with mainMod + scroll
                "$mod1, mouse_down, workspace, m+1"
                "$mod1, mouse_up, workspace, m-1"

                # Lock screen
                "$mod1, L, exec, hyprlock"

                # Shutdown
                "$mod1 $mod4, S, exec, systemctl poweroff"

                # Reboot
                "$mod1 $mod2 $mod4, R, exec,systemctl reboot"

                # Start Firefox
                "$mod1 $mod4, F, exec, firefox-esr"
                ", XF86HomePage, exec, firefox-esr"

                # Start Firefox in private window
                "$mod1 $mod2 $mod4, F, exec, firefox-esr --private-window"

                # Start jellyfin media player
                "$mod1, code:90, exec, jellyfinmediaplayer"

                # Start FreeTube
                "$mod1, code:87, exec, freetube"

                # Open file browser
                "$mod1, code:88, exec, nemo"

                # Open Steam
                "$mod1, code:84, exec, steam"

                ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""
            ];

            bindm = [
                "$mod1, mouse:272, movewindow"
                "$mod1, mouse:273, resizewindow"
            ];

            env = [
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "GDK_BACKEND,wayland"
                "QT_QPA_PLATFORM,wayland"
                "SDL_VIDEODRIVER,wayland"
                "CLUTTER_BACKEND,wayland"
                "NIXOS_OZONE_WL,1"
            ];

            exec-once = lib.lists.flatten [
                "eww daemon"
                (builtins.map
                    (b:
                        "eww open ${b.name}"
                    )
                    (config.eww.bars)
                )
                (builtins.map
                    (w:
                        "eww open ${w.name}"
                    )
                    (config.eww.widgets)
                )
                "dunst"
                "hyprpaper"
            ];

            monitor = map
                (m:
                    let
                        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
                        position = "${toString m.x}x${toString m.y}";
                        transform = {"0" = "0"; "90"= "3"; "180" = "2"; "270" = "1";};
                        vrr = {"off" = "0"; "on" = "2";};
                    in
                    "${m.name},${resolution},${position},1,transform,${transform.${toString m.transform}},vrr,${vrr.${m.adaptive_sync}}"
                )
                (config.monitors.outputs);

            windowrulev2 = lib.lists.flatten [
                (map (w:
                    map (p:
                        let
                            wsfocus = (if p.focus then "workspace ${w.name}" else "workspace ${w.name} silent");
                        in
                        "${wsfocus}, class:${p.name}"
                    )(w.programs)
                )(config.workspaces))
                "noanim, class:FreeTube"
                "tile, title:^(Chatterino\\s\\d\\.\\d\\.\\d)"
                "center, title:^(Chatterino Settings)"
                "center, class:(chatterino), title:^(Open channel)"
                "float, title:^(Steam Settings)"
            ];

            workspace = lib.lists.flatten (map 
                (m:
                    map (w:
                        "name:${w},monitor:${m.name}"
                    )(m.workspaces)
                )(config.monitors.outputs)
            );

            input = {
                "kb_layout" = "se";
                "kb_variant" = "nodeadkeys";
                "kb_model" = "";
                "kb_options" = "";
                "kb_rules" = "";
                "numlock_by_default" = true;

                "follow_mouse" = "1";

                touchpad = {
                    "natural_scroll" = "no";
                };

                "sensitivity" = "0";
            };

            general = {
                "gaps_in" = "2";
                "gaps_out" = "5";
                "border_size" = "3";
                "no_border_on_floating" = false;
                "col.active_border" = "rgba(33ccffee) rgba(ff00ddee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";

                layout = "hy3";
            };

            decoration = {
                rounding = "10";

                active_opacity = "1.0";
                inactive_opacity = "1.0";
                fullscreen_opacity = "1.0";
                dim_inactive = false;
                dim_strength = "0.5";
                "drop_shadow" = true;
                "shadow_range" = "4";
                "shadow_render_power" = "1";
                "col.shadow" = "rgba(101010ee)";

                blur = {
                    enabled = true;
                    size = "3";
                    passes = "1";
                    new_optimizations = true;
                };
            };

            animations = {
                enabled = false;
                first_launch_animation = false;
            };

            dwindle = {
                pseudotile = false;
                force_split = "2";
                preserve_split = true;
                smart_split = false;
                smart_resizing = true;
                no_gaps_when_only = "0";
            };

            master = {
                allow_small_split = false;
                new_status = "slave";
                no_gaps_when_only = "0";
                orientation = "left";
                mfact = "0.5";
            };

            gestures = {
                "workspace_swipe" = "off";
            };

            misc = {
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                focus_on_activate = true;
                new_window_takes_over_fullscreen = "1";
            };

            binds = {
                workspace_center_on = 1;
            };

            plugin = {
                hy3 = {
                    no_gaps_when_only = 1;

                    autotile = {
                        enable = false;
                        workspaces = "not:2";
                    };
                };
            };
        };
    };
    xdg.configFile."hypr/hyprpaper.conf".text = 
        lib.strings.concatStringsSep "\n" (map (m:
            "preload = ${m.background}"
        )(config.monitors.outputs)) + "\n" +
        lib.strings.concatStringsSep "\n" (map (m:
            "wallpaper = ${m.name},${m.background}"
        )(config.monitors.outputs)) + "\n" +
        ''splash = false'';

}