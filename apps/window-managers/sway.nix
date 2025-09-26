{
    pkgs,
    config,
    lib,
    ...
}:
let
    mod1 = "Mod4";
    # mod2 = "Ctrl";
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

    cfg.keyboard = config.input.keyboard;

    wsf = lib.lists.flatten (
        builtins.map (
            w:
            builtins.map (
                p:
                let
                    wsfocus = (
                        if p.focus then
                            "for_window [app_id=\"${p.name}\"] focus\nfor_window [class=\"${p.name}\"] focus\n"
                        else
                            ""
                    );
                in
                "${wsfocus}"
            ) (w.programs)
        ) (config.workspaces)
    );

    # Generate keybinds specified in config.keybinds inside home-manager config
    # and will then get appended to keybinds in sway config
    keybinds = builtins.foldl' (
        acc: attr:
        let
            modKeys = (if attr.mod != [ ] then lib.strings.concatStringsSep "+" attr.mod else "");
            keymod = (if modKeys != "" then "${modKeys}+${attr.key}" else "${attr.key}");
            program = "exec ${attr.program}";
        in
        acc // { "${keymod}" = program; }
    ) { } (config.keybindings ++ config.keybindings-multi);
in
{
    wayland.windowManager.sway = {
        config = {
            assigns = (
                builtins.listToAttrs (
                    builtins.map (w: {
                        name = w.name;
                        value = lib.lists.flatten (
                            map (p: [
                                { app_id = p.name; }
                                { class = p.name; }
                            ]) (w.programs)
                        );
                    }) (config.workspaces)
                )
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
                    { app_id = "zenity"; }
                    { window_role = "pop-up"; }
                    { window_role = "task_dialog"; }
                    {
                        app_id = "^floorp$";
                        title = "^Extension: \\(Bitwarden Password Manager\\) - Bitwarden — Ablaze Floorp$";
                    }
                    {
                        app_id = "^firefox$";
                        title = "^Extension: \\(Bitwarden Password Manager\\) - Bitwarden — Mozilla Firefox$";
                    }
                ];
                modifier = "${mod1}";
                titlebar = false;
            };
            focus = {
                followMouse = "yes";
                newWindow = "none";
            };
            fonts = { };
            gaps = {
                inner = config.gaps;
                outer = -config.gaps;
                smartBorders = "on";
                smartGaps = true;
            };
            input = {
                "1003:34842:Atmel_Atmel_maXTouch_Digitizer" = {
                    events = "disabled";
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
                    xkb_layout = (
                        if cfg.keyboard.variant != "" then
                            "${cfg.keyboard.language}(${cfg.keyboard.variant})"
                        else
                            "${cfg.keyboard.language}"
                    );
                    xkb_numlock = (if cfg.keyboard.numlock then "enable" else "disable");
                };
            };
            keybindings = {

                # Lock screen
                "${mod1}+l" = "exec swaylock";

                # kill focused window
                "${mod3}+F4" = "kill";

                # Resize mode
                "${mod1}+r" = "mode \"resize\"";

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
                "${mod1}+${mod4}+e" =
                    "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

                # Printscreen
                "Print" = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";

            }
            // keybinds;
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
                builtins.listToAttrs (
                    builtins.map (
                        m:
                        let
                            position = "${toString m.x} ${toString m.y}";
                            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz";
                        in
                        {
                            name = m.name;
                            value = {
                                adaptive_sync = m.adaptive_sync;
                                pos = position;
                                resolution = resolution;
                                transform = "${toString m.transform}";
                            };
                        }
                    ) (config.monitors.outputs)
                )
            );

            seat = {
                "seat0" = {
                    xcursor_theme = "${config.gtk.cursorTheme.name} " + toString config.gtk.cursorTheme.size;
                };
            };
            startup = lib.lists.flatten [
                { command = "systemctl --user import-environment PATH"; }
                (
                    if config.monitors.primary != "" then
                        [
                            { command = "${pkgs.xorg.xrandr}/bin/xrandr --output ${config.monitors.primary} --primary"; }
                        ]
                    else
                        [ ]
                )
                { command = "${pkgs.ngb}/bin/ngb"; }
                {
                    command = "kanshi";
                    always = true;
                }
            ];
            window = {
                border = 1;
                hideEdgeBorders = "none";
                titlebar = false;
            };
            workspaceAutoBackAndForth = false;
            workspaceLayout = "default";
            workspaceOutputAssign = lib.lists.flatten (
                map (
                    m:
                    map (w: {
                        output = m.name;
                        workspace = w;
                    }) (m.workspaces)
                ) (config.monitors.outputs)
            );
        };
        enable = true;
        extraConfig = ''
            ${lib.strings.concatStringsSep "" wsf}
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
