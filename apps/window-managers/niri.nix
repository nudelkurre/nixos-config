{
    pkgs,
    config,
    lib,
    ...
}:
let
    keyCodes = {
        "kp_0" = "KP_Insert";
        "kp_1" = "KP_End";
        "kp_2" = "KP_Down";
        "kp_3" = "KP_Next";
        "kp_4" = "KP_Left";
        "kp_5" = "KP_Begin";
        "kp_6" = "KP_Right";
        "kp_7" = "KP_Home";
        "kp_8" = "KP_Up";
        "kp_9" = "KP_Prior";
        "Mod4" = "Mod";
    };
    replaceKeys =
        str:
        let
            keys = builtins.attrNames keyCodes;
            replaceSubstring =
                acc: key:
                if builtins.match (".*" + key + ".*") acc != null then
                    builtins.replaceStrings [ key ] [ keyCodes.${key} ] acc
                else
                    acc;
        in
        builtins.foldl' replaceSubstring str keys;

    splitProgram =
        inputProgram:
        let
            splitProgram = lib.strings.splitString " " inputProgram;
            quotedProgram = map (s: ''"'' + s + ''"'') splitProgram;
            appendedProgram = builtins.concatStringsSep " " quotedProgram;
        in
        appendedProgram;

    keybinds = lib.strings.concatStringsSep "\n\t" (
        map (
            attr:
            let
                modKeys = (if attr.mod != [ ] then lib.strings.concatStringsSep "+" attr.mod else "");
                keymod = (if modKeys != "" then "${modKeys}+${attr.key}" else "${attr.key}");
                program = "${splitProgram attr.program}";
                title = (
                    if attr.overlay-title != "" then " hotkey-overlay-title=\"${attr.overlay-title}\" " else ""
                );
            in
            ''${replaceKeys keymod}${title} repeat=false { spawn ${program}; }''
        ) (config.keybindings)
    );

    keybinds-multi = lib.strings.concatStringsSep "\n\t" (
        map (
            attr:
            let
                modKeys = (if attr.mod != [ ] then lib.strings.concatStringsSep "+" attr.mod else "");
                keymod = (if modKeys != "" then "${modKeys}+${attr.key}" else "${attr.key}");
                program = "${attr.program}";
                title = (
                    if attr.overlay-title != "" then " hotkey-overlay-title=\"${attr.overlay-title}\" " else ""
                );
            in
            ''${replaceKeys keymod}${title} repeat=false { spawn-sh "${program}"; }''
        ) (config.keybindings-multi)
    );

    outputs = lib.strings.concatStringsSep "\n" (map
    (m:
        let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            transform = {"0" = "normal"; "90"= "270"; "180" = "180"; "270" = "90";};
            vrr = {"off" = "false"; "on" = "true";};
            backdrop-color = if m.wallpaper == "none" then "backdrop-color \"#000000\"" else "";
        in
        ''output "${m.name}" {
            mode "${resolution}"
            scale 1
            transform "${transform.${toString m.transform}}"
            position x=${toString m.x} y=${toString m.y}
            variable-refresh-rate on-demand=${vrr.${m.adaptive_sync}}
            ${backdrop-color}
        }
        ''
    )
    (config.monitors.outputs));

    workspaceOutput = lib.strings.concatStringsSep "\n" (
        lib.lists.flatten (
            builtins.map (
                m:
                builtins.map (
                    w:
                    let
                        ws = w;
                        output = m.name;
                    in
                    ''
                        workspace "${ws}" {
                            open-on-output "${output}"
                        }
                    ''
                ) (m.workspaces)
            ) (config.monitors.outputs)
        )
    );

    workspacePrograms = lib.strings.concatStringsSep "\n" (
        lib.lists.flatten (
            builtins.map (
                w:
                builtins.map (
                    p:
                    let
                        ws = w.name;
                        program = p.name;
                        focus = (if p.focus then "true" else "false");
                    in
                    ''
                        window-rule {
                            match app-id="${program}"
                            open-on-workspace "${ws}"
                            open-focused ${focus}
                        }
                    ''
                ) (w.programs)
            ) (config.workspaces)
        )
    );

    cfg.keyboard = config.input.keyboard;
    cfg.mouse = config.input.mouse;
    cfg.touchpad = config.input.touchpad;

    color1 = "#33ccff";
    color2 = "#ff96ff";
    opacity_active = "ee";
    opacity_inactive = "33";
    color_angle = "45";
in
{
    home.packages = [ pkgs.niri ];
    systemd.user.targets."niri-session" = {
        Unit = {
            After = "graphical-session-pre.target";
            BindsTo = "graphical-session.target";
            Description = "niri compositor session";
            Documentation = [ "man:systemd.special(7)" ];
            Wants = "graphical-session-pre.target";
        };
    };
    xdg.configFile."niri/config.kdl".text = ''
        input {
            keyboard {
                xkb {
                    // You can set rules, model, layout, variant and options.
                    // For more information, see xkeyboard-config(7).

                    // For example:
                    // layout "se(nodeadkeys)"
                    layout "${
                        (
                            if cfg.keyboard.variant != "" then
                                "${cfg.keyboard.language}(${cfg.keyboard.variant})"
                            else
                                "${cfg.keyboard.language}"
                        )
                    }"
                    // options "compose:ralt"
                }
                ${(if cfg.keyboard.numlock then "numlock" else "")}
            }

            // Next sections include libinput settings.
            // Omitting settings disables them, or leaves them at their default values.
            ${
                (
                    if cfg.touchpad.enable then
                        ''
                            touchpad {
                                ${(if cfg.touchpad.natural-scroll then "natural-scroll" else "")}
                                ${(if cfg.touchpad.scroll-method != "" then "scroll-method ${cfg.touchpad.scroll-method}" else "")}
                                ${(if cfg.touchpad.disable-on-mouse then "disabled-on-external-mouse" else "")}
                                }
                        ''
                    else
                        ''
                            touchpad {
                                    off
                                }
                        ''
                )
            }
            ${
                (
                    if cfg.mouse.enable then
                        ''
                            mouse {
                                    ${(if cfg.mouse.natural-scroll then "natural-scroll" else "")}
                                }
                        ''
                    else
                        ''
                            mouse {
                                    off
                                }
                        ''
                )
            }

            focus-follows-mouse max-scroll-amount="25%"

            mod-key "Super"
            mod-key-nested "Alt"
        }

        ${outputs}

        layout {
            gaps ${toString config.gaps}

            background-color "transparent"

            center-focused-column "never"

            default-column-display "normal"

            preset-column-widths {
                proportion 0.5
                proportion 1.0
            }

            preset-window-heights {
                proportion 0.5
                proportion 1.0
            }

            default-column-width {
                proportion 1.0
            }
            
            insert-hint {
                gradient from="${color1}" to="${color2}" angle=${color_angle}
            }

            border {
                off
            }
            
            shadow {
                // Uncomment the next line to enable shadows.
                // on

                // By default, the shadow draws only around its window, and not behind it.
                // Uncomment this setting to make the shadow draw behind its window.
                //
                // Note that niri has no way of knowing about the CSD window corner
                // radius. It has to assume that windows have square corners, leading to
                // shadow artifacts inside the CSD rounded corners. This setting fixes
                // those artifacts.
                // 
                // However, instead you may want to set prefer-no-csd and/or
                // geometry-corner-radius. Then, niri will know the corner radius and
                // draw the shadow correctly, without having to draw it behind the
                // window. These will also remove client-side shadows if the window
                // draws any.
                // 
                // draw-behind-window true

                // You can change how shadows look. The values below are in logical
                // pixels and match the CSS box-shadow properties.

                // Softness controls the shadow blur radius.
                softness 30

                // Spread expands the shadow.
                spread 5

                // Offset moves the shadow relative to the window.
                offset x=0 y=5

                // You can also change the shadow color and opacity.
                color "#0007"
            }

            tab-indicator {
                width 8
                gap 4
                gaps-between-tabs 4
                corner-radius 10
                hide-when-single-tab
                length total-proportion=1.0
                position "left"
                place-within-column
                active-gradient from="${color1}${opacity_active}" to="${color2}${opacity_active}" angle=0
                inactive-gradient from="${color1}${opacity_inactive}" to="${color2}${opacity_inactive}" angle=0
            }
        }

        prefer-no-csd

        screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

        animations {
            workspace-switch {
                off
            }

            window-open {
                off
            }

            window-close {
                off
            }

            horizontal-view-movement {
                off
            }

            window-movement {
                off
            }

            window-resize {
                duration-ms 150
                curve "ease-out-expo"
            }

            config-notification-open-close {
                off
            }

            screenshot-ui-open {
                off
            }

            overview-open-close {
                duration-ms 250
                curve "ease-out-expo"
            }
        }

        cursor {
            xcursor-theme "${config.gtk.cursorTheme.name}"
            xcursor-size ${toString config.gtk.cursorTheme.size}
        }

        gestures {
            hot-corners {
                off
            }
        }

        environment {
            XDG_CURRENT_DESKTOP "niri"
            NIXOS_OZONE_WL "1"
        }

        ${workspaceOutput}

        ${workspacePrograms}

        window-rule {
            match app-id="Alacritty"
            match app-id="nemo"
            default-column-width {
                proportion 0.5;
            }
        }

        window-rule {
            match title="Bitwarden"
            open-floating true
            open-focused true

            default-window-height { proportion 0.75; }
            default-column-width { proportion 0.5; }

            block-out-from "screen-capture"
        }

        window-rule {
            match app-id="pcsx2-qt"
            exclude title=r#"^PCSX2 v\d+\.\d+\.\d+$"#
            open-floating true
        }

        window-rule {
            match app-id="steam"
            exclude title=r#"^Steam$"#
            exclude app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
            open-floating true
        }

        window-rule {
            match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
            open-focused false
            default-floating-position x=10 y=10 relative-to="top-right"
        }

        window-rule {
            geometry-corner-radius 15
            clip-to-geometry true
        }

        window-rule {
            match app-id="firefox" title=r#"^Save As$"#
            match app-id="firefox" title=r#"^Enter name of file to save to…$"#
            default-window-height { proportion 0.75; }
            default-column-width { proportion 0.5; }
        }

        window-rule {
            match app-id="com.chatterino.chatterino"
            exclude app-id="com.chatterino.chatterino" title=r#"^Chatterino \d+.\d+.\d+"#
            default-window-height { proportion 0.5; }
            open-floating true
        }

        window-rule {
            match is-focused=true
            focus-ring {
                width 2
                active-gradient from="${color1}${opacity_active}" to="${color2}${opacity_active}" angle=${color_angle} relative-to="workspace-view"
                inactive-gradient from="${color1}${opacity_inactive}" to="${color2}${opacity_inactive}" angle=${color_angle} relative-to="workspace-view"
            }
        }

        window-rule {
            match is-focused=false
            focus-ring {
                off
            }
        }

        layer-rule {
            match namespace="^swww-daemon$"
            match namespace="^mpvpaper$"
            place-within-backdrop true
        }

        layer-rule {
            match namespace="^notifications$"
            block-out-from "screen-capture"
        }

        binds {
            Mod+F1 { show-hotkey-overlay; }

            Mod+F2 cooldown-ms=200 { toggle-overview; }

            Mod+L hotkey-overlay-title="Lock screen" { spawn "${pkgs.gtklock}/bin/gtklock" "-f" "-S"; }

            Alt+F4 hotkey-overlay-title=null { close-window; }

            // Focus windows
            Mod+Left  { focus-column-left; }
            Mod+Down  { focus-window-down; }
            Mod+Up    { focus-window-up; }
            Mod+Right { focus-column-right; }
            Mod+WheelScrollUp { focus-window-up; }
            Mod+WheelScrollDown { focus-window-down; }
            Mod+MouseForward { focus-column-right; }
            Mod+MouseBack { focus-column-left; }

            // Move windows
            Mod+Shift+Left  { move-column-left; }
            Mod+Shift+Down  { move-window-down; }
            Mod+Shift+Up    { move-window-up; }
            Mod+Shift+Right { move-column-right; }

            Mod+Home { focus-column-first; }
            Mod+End  { focus-column-last; }
            Mod+Shift+Home { move-column-to-first; }
            Mod+Shift+End  { move-column-to-last; }

            Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
            Mod+Shift+Ctrl+Down  { move-window-to-monitor-down; }
            Mod+Shift+Ctrl+Up    { move-window-to-monitor-up; }
            Mod+Shift+Ctrl+Right { move-window-to-monitor-right; }

            Mod+1 { focus-workspace "1"; }
            Mod+2 { focus-workspace "2"; }
            Mod+3 { focus-workspace "3"; }
            Mod+4 { focus-workspace "4"; }
            Mod+5 { focus-workspace "5"; }
            Mod+6 { focus-workspace "6"; }
            Mod+7 { focus-workspace "7"; }
            Mod+8 { focus-workspace "8"; }
            Mod+9 { focus-workspace "9"; }
            Mod+0 { focus-workspace "10"; }
            Mod+Shift+1 { move-window-to-workspace "1" focus=false; }
            Mod+Shift+2 { move-window-to-workspace "2" focus=false; }
            Mod+Shift+3 { move-window-to-workspace "3" focus=false; }
            Mod+Shift+4 { move-window-to-workspace "4" focus=false; }
            Mod+Shift+5 { move-window-to-workspace "5" focus=false; }
            Mod+Shift+6 { move-window-to-workspace "6" focus=false; }
            Mod+Shift+7 { move-window-to-workspace "7" focus=false; }
            Mod+Shift+8 { move-window-to-workspace "8" focus=false; }
            Mod+Shift+9 { move-window-to-workspace "9" focus=false; }
            Mod+Shift+0 { move-window-to-workspace "10" focus=false; }

            // Change focus om workspace by scroll up or down
            Mod+Shift+WheelScrollDown { focus-workspace-down; }
            Mod+Shift+WheelScrollUp { focus-workspace-up; }

            // The following binds move the focused window in and out of a column.
            // If the window is alone, they will consume it into the nearby column to the side.
            // If the window is already in a column, they will expel it out.
            Mod+Ctrl+8  { consume-or-expel-window-left; }
            Mod+Ctrl+9 { consume-or-expel-window-right; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { fullscreen-window; }
            Mod+Ctrl+F { toggle-windowed-fullscreen; }

            // Change column width
            Mod+Alt+Left { set-column-width "-5%"; }
            Mod+Alt+Right { set-column-width "+5%"; }

            // Change window height
            Mod+Alt+Down { set-window-height "+5%"; }
            Mod+Alt+Up { set-window-height "-5%"; }

            Mod+C { center-column; }

            // Move the focused window between the floating and the tiling layout.
            Mod+Shift+Space       { toggle-window-floating; }
            Mod+Ctrl+Shift+Space { switch-focus-between-floating-and-tiling; }

            Mod+W { toggle-column-tabbed-display; }

            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }

            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

            // The quit action will show a confirmation dialog to avoid accidental exits.
            Mod+Shift+E { quit; }

            // Generated keybinds
            ${keybinds}

            // Generated keybinds-multi
            ${keybinds-multi}
        }

        hotkey-overlay {
            skip-at-startup
            hide-not-bound
        }

        overview {
            zoom 0.75
            workspace-shadow {
                off
            }
        }

        xwayland-satellite {
            path "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
        }

        spawn-at-startup "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "DISPLAY" "WAYLAND_DISPLAY" "SWAYSOCK" "XDG_CURRENT_DESKTOP" "XDG_SESSION_TYPE" "NIXOS_OZONE_WL" "XCURSOR_THEME" "XCURSOR_SIZE"
    '';
}
