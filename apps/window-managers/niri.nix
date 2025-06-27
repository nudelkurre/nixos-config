{pkgs, config, lib, ...}:
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
    replaceKeys = str: 
        let
            keys = builtins.attrNames keyCodes;
            replaceSubstring = acc: key: 
                if builtins.match (".*" + key + ".*") acc != null then
                    builtins.replaceStrings [key] [keyCodes.${key}] acc
                else
                    acc;
        in
        builtins.foldl' replaceSubstring str keys;

    splitProgram = inputProgram:
        let
            splitProgram = lib.strings.splitString " " inputProgram;
            quotedProgram = map (s: ''"'' + s + ''"'') splitProgram;
            appendedProgram = builtins.concatStringsSep " " quotedProgram;
        in
            appendedProgram;

    keybinds = lib.strings.concatStringsSep "\n\t" (map (attr:
        let
            modKeys = (if attr.mod != [] then lib.strings.concatStringsSep "+" attr.mod else "");
            keymod = (if modKeys != "" then "${modKeys}+${attr.key}" else "${attr.key}");
            program = "${splitProgram attr.program}";
        in
        ''${replaceKeys keymod} { spawn ${program}; }''
        )(config.keybindings));

    outputs = lib.strings.concatStringsSep "\n" (map
        (m:
            let
                refreshrate = {"144" = "143.856"; "120" = "119.881"; "60" = "60";};
                resolution = "${toString m.width}x${toString m.height}@${refreshrate.${toString m.refreshRate}}";
                transform = {"0" = "normal"; "90"= "270"; "180" = "180"; "270" = "90";};
                vrr = {"off" = ""; "on" = "variable-refresh-rate";};
            in
            ''output "${m.name}" {
                mode "${resolution}"
                scale 1
                transform "${transform.${toString m.transform}}"
                position x=${toString m.x} y=${toString m.y}
                ${vrr.${m.adaptive_sync}}
            }
            ''
        )
        (config.monitors.outputs));

    workspaceOutput = lib.strings.concatStringsSep "\n" (lib.lists.flatten (builtins.map (m:
        builtins.map (w:
            let
                ws = w;
                output = m.name;
            in
''workspace "${ws}" {
    open-on-output "${output}"
}
''
        )(m.workspaces)
    )(config.monitors.outputs)));

    workspacePrograms = lib.strings.concatStringsSep "\n" (lib.lists.flatten (builtins.map (w:
        builtins.map (p:
            let
                ws = w.name;
                program = p.name;
                focus = (if p.focus then "true" else "false");
            in
''window-rule {
    match app-id="${program}"
    open-on-workspace "${ws}"
    open-focused ${focus}
}
''
        )(w.programs)
    )(config.workspaces)));
    
    cfg.keyboard = config.input.keyboard;
    cfg.mouse = config.input.mouse;
    cfg.touchpad = config.input.touchpad;
in
{
    home.packages = [pkgs.unstable.niri];
    xdg.configFile."niri/config.kdl" = {
        text = ''
input {
    keyboard {
        xkb {
            // You can set rules, model, layout, variant and options.
            // For more information, see xkeyboard-config(7).

            // For example:
            // layout "se(nodeadkeys)"
            layout "${(if cfg.keyboard.variant != "" then "${cfg.keyboard.language}(${cfg.keyboard.variant})" else "${cfg.keyboard.language}")}"
            // options "compose:ralt"
        }
        ${(if cfg.keyboard.numlock then "numlock" else "")}
    }

    // Next sections include libinput settings.
    // Omitting settings disables them, or leaves them at their default values.
    ${(if cfg.touchpad.enable then ''
    touchpad {
        ${(if cfg.touchpad.natural-scroll then "natural-scroll" else "")}
        ${(if cfg.touchpad.scroll-method != "" then "scroll-method cfg.touchpad.scroll-method" else "")}
        ${(if cfg.touchpad.disable-on-mouse then "disabled-on-external-mouse" else "")}
        }
    '' else ''
    touchpad {
            off
        }
    '')}
    ${(if cfg.mouse.enable then ''
    mouse {
            ${(if cfg.mouse.natural-scroll then "natural-scroll" else "")}
        }
    '' else ''
    mouse {
            off
        }
    '')}

    warp-mouse-to-focus
    focus-follows-mouse

    mod-key "Super"
    mod-key-nested "Alt"
}

${outputs}

layout {
    gaps 5

    center-focused-column "never"

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
        proportion 1.0
    }

    preset-window-heights {
        proportion 0.5
        proportion 1.0
    }

    default-column-width {
        proportion 1.0
    }
    
    focus-ring {
        width 2
        active-gradient from="#33ccffee" to="#ff00ddee" angle=45 relative-to="workspace-view"
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
}

prefer-no-csd

screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

animations {
    // Uncomment to turn off all animations.
    off
}

environment {
    XDG_CURRENT_DESKTOP "niri"
    NIXOS_OZONE_WL "1"
}

${workspaceOutput}

${workspacePrograms}

binds {
    Mod+Shift+7 { show-hotkey-overlay; }

    Mod+Return { spawn "alacritty"; }
    Mod+D { spawn "rofi" "-show"; }
    Mod+L { spawn "swaylock"; }

    Alt+F4 { close-window; }

    Mod+Left  { focus-column-left; }
    Mod+Down  { focus-window-down; }
    Mod+Up    { focus-window-up; }
    Mod+Right { focus-column-right; }

    Mod+Ctrl+Left  { move-column-left; }
    Mod+Ctrl+Down  { move-window-down; }
    Mod+Ctrl+Up    { move-window-up; }
    Mod+Ctrl+Right { move-column-right; }
    Mod+Ctrl+H     { move-column-left; }
    Mod+Ctrl+J     { move-window-down; }
    Mod+Ctrl+K     { move-window-up; }
    Mod+Ctrl+L     { move-column-right; }

    Mod+Home { focus-column-first; }
    Mod+End  { focus-column-last; }
    Mod+Ctrl+Home { move-column-to-first; }
    Mod+Ctrl+End  { move-column-to-last; }

    Mod+Shift+Left  { focus-monitor-left; }
    Mod+Shift+Down  { focus-monitor-down; }
    Mod+Shift+Up    { focus-monitor-up; }
    Mod+Shift+Right { focus-monitor-right; }

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
    Mod+Ctrl+1 { move-window-to-workspace "1"; }
    Mod+Ctrl+2 { move-window-to-workspace "2"; }
    Mod+Ctrl+3 { move-window-to-workspace "3"; }
    Mod+Ctrl+4 { move-window-to-workspace "4"; }
    Mod+Ctrl+5 { move-window-to-workspace "5"; }
    Mod+Ctrl+6 { move-window-to-workspace "6"; }
    Mod+Ctrl+7 { move-window-to-workspace "7"; }
    Mod+Ctrl+8 { move-window-to-workspace "8"; }
    Mod+Ctrl+9 { move-window-to-workspace "9"; }
    Mod+Ctrl+0 { move-window-to-workspace "10"; }

    // The following binds move the focused window in and out of a column.
    // If the window is alone, they will consume it into the nearby column to the side.
    // If the window is already in a column, they will expel it out.
    Mod+Shift+8  { consume-or-expel-window-left; }
    Mod+Shift+9 { consume-or-expel-window-right; }

    Mod+R { switch-preset-column-width; }
    Mod+Shift+R { switch-preset-window-height; }
    Mod+Ctrl+R { reset-window-height; }
    Mod+F { fullscreen-window; }

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
}
        '';
    };
}