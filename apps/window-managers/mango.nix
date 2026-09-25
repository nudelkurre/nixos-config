{
    pkgs,
    config,
    osConfig,
    lib,
    ...
}:
let
    keyCodes = {
        "Mod4" = "SUPER";
        "Shift" = "SHIFT";
        "Ctrl" = "CTRL";
        "Alt" = "ALT";
        "10" = "0";
    };
    replaceKeys = str: if builtins.hasAttr str keyCodes then keyCodes.${str} else str;
    keybinds = map (
        attr:
        let
            modKeys =
                if attr.mod != [ ] then lib.strings.concatStringsSep "+" (map replaceKeys attr.mod) else "NONE";
        in
        "${modKeys},${replaceKeys attr.key},spawn,${attr.program}"
    ) (config.keybindings);
    keybinds-multi = map (
        attr:
        let
            modKeys =
                if attr.mod != [ ] then lib.strings.concatStringsSep "+" (map replaceKeys attr.mod) else "NONE";
        in
        "${modKeys},${replaceKeys attr.key},spawn_shell,${attr.program}"
    ) (config.keybindings-multi);
    workspace_outputs = builtins.listToAttrs (
        builtins.concatMap (output:
            map (workspace: {
                name = workspace;
                value = output.name;
            })
            output.workspaces
        )osConfig.monitors.outputs
    );
    monitor_focus = map (tag: "SUPER,${replaceKeys (toString tag)},viewcrossmon,${tag},${workspace_outputs.${toString tag}}") (map toString (lib.range 1 (lib.lists.length config.workspaces)));
    monitor_move = map (tag: "SUPER+SHIFT,${replaceKeys (toString tag)},tagcrossmon,${tag},${workspace_outputs.${toString tag}}") (map toString (lib.range 1 (lib.lists.length config.workspaces)));
    monitor = map (
        m:
        let
            transform = {
                "0" = "0";
                "90" = "3";
                "180" = "2";
                "270" = "1";
            };
            vrr = {
                "off" = "0";
                "on" = "1";
            };
        in
        "name:${m.name},width:${toString m.width},height:${toString m.height},refresh:${toString m.refreshRate},x:${toString m.x},y:${toString m.y},vrr:${vrr.${m.adaptive_sync}},rr:${
            transform.${toString m.transform}
        }"
    ) (osConfig.monitors.outputs);
    windows = (
        map (
            w:
            map (
                p:
                let
                    name = "appid:${lib.strings.toLower p.name}";
                    silent = if p.focus then "isopensilent:0" else "isopensilent:1";
                    tag = "tags:${w.name}";
                    monitor = "monitor:${workspace_outputs.${w.name}}";
                in
                "${name},${silent},${tag},${monitor}"
            ) (w.programs)
        ) (config.workspaces)
    );
    workspaces = (
        map (
            m:
            map (
                w:
                let
                    ws = w;
                    output = m.name;
                in
                "id:${ws},monitor_name:${output}"
            ) (m.workspaces)
        ) (osConfig.monitors.outputs)
    );
    cfg.keyboard = config.input.keyboard;
    cfg.mouse = config.input.mouse;
    cfg.touchpad = config.input.touchpad;
in
{
    wayland.windowManager.mango = {
        enable = true;
        settings = {
            xkb_rules_layout = cfg.keyboard.language;
            xkb_rules_variant = cfg.keyboard.variant;
            numlockon = if cfg.keyboard.numlock then 1 else 0;

            mouse_natural_scrolling = if cfg.mouse.natural-scroll then 1 else 0;

            tap_to_click = if cfg.touchpad.tap then 1 else 0;
            trackpad_click_method = if cfg.touchpad.clickfinger then 2 else 1;
            trackpad_natural_scrolling = if cfg.touchpad.natural-scroll then 1 else 0;
            trackpad_scroll_method =
                if cfg.touchpad.scroll-method == "two-finger" then
                    1
                else if cfg.touchpad.scroll-method == "edge" then
                    2
                else
                    4;
            trackpad_send_events_mode = if cfg.touchpad.disable-on-mouse then 2 else 0;

            focus_on_activate = 0;
            sloppyfocus = 1;

            drag_tile_to_tile = 1;

            exchange_cross_monitor = 1;
            scratchpad_cross_monitor = 0;
            single_scratchpad = 1;

            no_border_when_single = 1;
            smartgaps = 1;

            animations = 0;
            layer_animations = 0;
            blur = 0;
            shadows = 0;

            borderpx = config.desktop.borders;
            border_radius = config.desktop.corner-radius;
            gappih = config.desktop.gaps;
            gappiv = config.desktop.gaps;
            gappoh = config.desktop.gaps;
            gappov = config.desktop.gaps;

            circle_layout = "scroller,tile,fair";

            tag_num = lib.lists.length config.workspaces;

            monitorrule = lib.lists.flatten [
                monitor
            ];

            bind = lib.lists.flatten [
                "ALT,F4,killclient"
                "SUPER+SHIFT,Space,togglefloating"
                "SUPER,f,togglefullscreen"
                "SUPER,r,reload_config"
                "SUPER+SHIFT,e,quit"
                "SUPER,F2,toggleoverview"
                "SUPER,Up,focusdir,up"
                "SUPER,Down,focusdir,down"
                "SUPER,Left,focusdir,left"
                "SUPER,Right,focusdir,right"
                "SUPER+Shift,Up,move_client,up"
                "SUPER+Shift,Down,move_client,down"
                "SUPER+Shift,Left,move_client,left"
                "SUPER+Shift,Right,move_client,right"
                "NONE,Print,spawn,${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""
                "SUPER,n,switch_layout"
                keybinds
                keybinds-multi
                monitor_focus
                monitor_move
            ];

            mousebind = [
                "SUPER,btn_left,moveresize,curmove"
                "SUPER,btn_right,moveresize,curresize"
            ];

            tagrule = lib.lists.flatten [
                workspaces
            ];

            windowrule = lib.lists.flatten [
                windows
            ];
        };
    };
}
