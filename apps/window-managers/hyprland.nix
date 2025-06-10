{pkgs, config, lib, ...}:
let
    keyCodes = {
        "kp_0" = "code:90";
        "kp_1" = "code:87";
        "kp_2" = "code:88";
        "kp_3" = "code:89";
        "kp_4" = "code:83";
        "kp_5" = "code:84";
        "kp_6" = "code:85";
        "kp_7" = "code:79";
        "kp_8" = "code:80";
        "kp_9" = "code:81";
        "kp_divide" = "code:106";
        "kp_multiply" = "code:63";
        "kp_subtract" = "code:82";
        "kp_add" = "code:86";
        "kp_enter" = "code:104";
        "kp_separator" = "code:91";
    };
    replaceKeys = str:
        if builtins.hasAttr str keyCodes then
            keyCodes.${str}
        else
            str;
in
{
    home = {
        packages = lib.optionals (config.wayland.windowManager.hyprland.enable == true) [
            pkgs.hyprpaper
        ];
    };
    wayland.windowManager.hyprland = {
        enable = ! config.disable.hyprland;
        package = pkgs.hyprland;
        plugins = [
            pkgs.hyprlandPlugins.hy3
        ];
        settings = {
            "$mod1" = "SUPER";
            "$mod2" = "CTRL";
            "$mod3" = "ALT";
            "$mod4" = "SHIFT";

            animations = {
                enabled = false;
                first_launch_animation = false;
            };

            bind = lib.lists.flatten [
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

                # Generate keybinds specified in config.keybinds inside home-manager config
                # and will then get appended to keybinds in hyprland config
                (map (attr:
                let
                    modKeys = (if attr.mod != [] then lib.strings.concatStringsSep " " (map lib.strings.toUpper attr.mod) else "");
                    keymod = (if modKeys != "" then "${modKeys}, ${replaceKeys attr.key}" else ", ${replaceKeys attr.key}");
                    program = "${attr.program}";
                in
                "${keymod}, exec, ${program}"
                )(config.keybindings))
            ];

            bindm = [
                "$mod1, mouse:272, movewindow"
                "$mod1, mouse:273, resizewindow"
            ];

            binds = {
                workspace_center_on = 1;
            };

            decoration = {
                active_opacity = "1.0";
                blur = {
                    enabled = true;
                    new_optimizations = true;
                    passes = "1";
                    size = "3";
                };
                dim_inactive = false;
                dim_strength = "0.5";
                fullscreen_opacity = "1.0";
                inactive_opacity = "1.0";
                rounding = "10";
            };

            dwindle = {
                force_split = "2";
                preserve_split = true;
                pseudotile = false;
                smart_resizing = true;
                smart_split = false;
            };

            env = [
                "CLUTTER_BACKEND,wayland"
                "GDK_BACKEND,wayland"
                "NIXOS_OZONE_WL,1"
                "QT_QPA_PLATFORM,wayland"
                "SDL_VIDEODRIVER,wayland"
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
            ];

            exec-once = lib.lists.flatten [
                "${pkgs.ngb}/bin/ngb"
                "dunst"
                "hyprpaper"
            ];

            general = {
                "border_size" = "3";
                "col.active_border" = "rgba(33ccffee) rgba(ff00ddee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";
                "gaps_in" = "2";
                "gaps_out" = "5";
                "layout" = "hy3";
                "no_border_on_floating" = false;
            };

            gestures = {
                "workspace_swipe" = "off";
            };

            input = {
                "follow_mouse" = "1";
                "kb_layout" = "se";
                "kb_model" = "";
                "kb_options" = "";
                "kb_rules" = "";
                "kb_variant" = "nodeadkeys";
                "numlock_by_default" = true;
                touchpad = {
                    "natural_scroll" = "no";
                };
                "sensitivity" = "0";
            };

            master = {
                allow_small_split = false;
                mfact = "0.5";
                new_status = "slave";
                orientation = "left";
            };

            misc = {
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                focus_on_activate = false;
                new_window_takes_over_fullscreen = "1";
            };

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

            plugin = {
                hy3 = {
                    autotile = {
                        enable = false;
                        workspaces = "not:2";
                    };
                    no_gaps_when_only = 1;
                };
            };

            windowrulev2 = lib.lists.flatten [
                (map (w:
                    map (p:
                        let
                            wsfocus = (if p.focus then "workspace ${w.name}" else "workspace ${w.name} silent");
                        in
                        "${wsfocus}, class:${p.name}"
                    )(w.programs)
                )(config.workspaces))
                "center, class:(chatterino), title:^(Open channel)"
                "center, title:^(Chatterino Settings)"
                "float, title:^(Steam Settings)"
                "move onscreen cursor, class:^(jellyfinmediaplayer), title:^(jellyfinmediaplayer)"
                "noanim, class:FreeTube"
                "noinitialfocus, class:^(com.chatterino.chatterino), title:(Usercard)"
                "tile, title:^(Chatterino\\s\\d\\.\\d\\.\\d)"
            ];

            workspace = lib.lists.flatten (map 
                (m:
                    map (w:
                        "name:${w},monitor:${m.name}"
                    )(m.workspaces)
                )(config.monitors.outputs)
            );
        };
        systemd = {
            enable = true;
        };
        xwayland = {
            enable = true;
        };
    };
    xdg = {
        configFile = {
            "hypr/hyprpaper.conf" = {
                enable = config.wayland.windowManager.hyprland.enable;
                text = 
                    lib.strings.concatStringsSep "\n" (map (m:
                        "preload = ${m.background}"
                    )(config.monitors.outputs)) + "\n" +
                    lib.strings.concatStringsSep "\n" (map (m:
                        "wallpaper = ${m.name},${m.background}"
                    )(config.monitors.outputs)) + "\n" +
                        ''splash = false'';
            };
        };
    };
}