{
    pkgs,
    config,
    osConfig,
    sharedSettings,
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

    # Generate single command keybindings
    keybinds = map (
        attr:
        let
            modKeys =
                if attr.mod != [ ] then lib.strings.concatStringsSep "+" (map replaceKeys attr.mod) else "NONE";
        in
        "${modKeys},${replaceKeys attr.key},spawn,${attr.program}"
    ) (config.keybindings);

    # Generate multi-command keybindings
    keybinds-multi = map (
        attr:
        let
            modKeys =
                if attr.mod != [ ] then lib.strings.concatStringsSep "+" (map replaceKeys attr.mod) else "NONE";
        in
        "${modKeys},${replaceKeys attr.key},spawn_shell,${attr.program}"
    ) (config.keybindings-multi);

    # Mapping workspace name to an index for each output
    workspace_outputs = builtins.listToAttrs (
        builtins.concatMap (output:
            builtins.genList (i: {
                name = builtins.elemAt output.workspaces i;
                value = {
                    index = i + 1;
                    output = output.name;
                };
            }) (builtins.length output.workspaces)
        )osConfig.monitors.outputs
    );

    # Generate keybindings to move and focus tags
    monitor_focus = lib.mapAttrsToList (tag: workspace: "SUPER,${replaceKeys (toString tag)},viewcrossmon,${toString workspace.index},${workspace.output}")(workspace_outputs);
    monitor_move = lib.mapAttrsToList (tag: workspace: "SUPER+SHIFT,${replaceKeys (toString tag)},tagcrossmon,${toString workspace.index},${workspace.output}")(workspace_outputs);

    # Settings for each monitor
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

    # Generate window rules from workspace settings in home manager
    windows = (
        map (
            w:
            map (
                p:
                let
                    name = "appid:${lib.strings.toLower p.name}";
                    silent = if p.focus then "isopensilent:0" else "isopensilent:1";
                    tag = "tags:${toString workspace_outputs.${w.name}.index}";
                    monitor = "monitor:${workspace_outputs.${w.name}.output}";
                in
                "${name},${silent},${toString tag},${monitor},allow_csd:0"
            ) (w.programs)
        ) (config.workspaces)
    );

    # Generating tagrules from monitor settings in nixos config
    workspaces = (
        map (
            m:
            map (
                w:
                let
                    ws = workspace_outputs.${w}.index;
                    output = m.name;
                    vertical = if m.transform == 90 || m.transform == 270 then "vertical_" else "";
                    layout =  "layout_name:${vertical}tile";
                    scroller_proportion = if vertical == "vertical_" then "0.5" else "1.0";
                in
                "id:${toString ws},monitor_name:${output},${layout},scroller_default_proportion:${scroller_proportion}"
            ) (m.workspaces)
        ) (osConfig.monitors.outputs)
    );

    # Get the amount of tags needed per monitor by taking the highest value
    # from counting each monitors configured tags
    max = a: b: if a > b then a else b;
    max_tags_num_list = map (tag: lib.lists.length tag.workspaces) (osConfig.monitors.outputs);
    max_tags_num = builtins.foldl' max (builtins.head max_tags_num_list) (builtins.tail max_tags_num_list);
    
    
    cfg.keyboard = config.input.keyboard;
    cfg.mouse = config.input.mouse;
    cfg.touchpad = config.input.touchpad;

    removeFirstCharacter = str: builtins.substring 1 (builtins.stringLength str - 1) str;
    variant = osConfig.theme.variant;
    base-color = removeFirstCharacter sharedSettings.colors."${variant}".base;
    text-color = removeFirstCharacter sharedSettings.colors."${variant}".text;
    main-color = removeFirstCharacter sharedSettings.colors."${variant}"."${osConfig.theme.color.main}";
    secondary-color = removeFirstCharacter sharedSettings.colors."${variant}"."${osConfig.theme.color.secondary}";
    urgent-color = removeFirstCharacter sharedSettings.colors."${variant}".red;
in
{
    wayland.windowManager.mango = {
        autostart_sh = ''
            ${pkgs.writeShellScript "notify_keymode_change" ''
                ${config.wayland.windowManager.mango.package}/bin/mmsg watch keymode |
                while IFS= read -r message; do
                    msg=$(echo $message | ${pkgs.jq}/bin/jq '.keymode')
                    ${pkgs.libnotify}/bin/notify-send "Mango keymode changed to $msg"
                done
            ''} &
        '';
        enable = true;
        settings = {
            # Keyboard setting
            xkb_rules_layout = cfg.keyboard.language;
            xkb_rules_variant = cfg.keyboard.variant;
            numlockon = if cfg.keyboard.numlock then 1 else 0;

            # Mouse settings
            mouse_natural_scrolling = if cfg.mouse.natural-scroll then 1 else 0;

            # Touchpad settings
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

            # Window focus
            focus_on_activate = 0;
            sloppyfocus = 1;

            drag_tile_to_tile = 1;

            exchange_cross_monitor = 1;
            scratchpad_cross_monitor = 1;
            single_scratchpad = 1;

            # Border and gaps settings
            no_border_when_single = 0;
            smartgaps = 0;

            # Animation and blur
            animations = 0;
            layer_animations = 0;
            blur = 0;
            shadows = 0;

            # Border looks
            borderpx = config.desktop.borders;
            border_radius = config.desktop.corner-radius;
            # gappih = config.desktop.gaps;
            # gappiv = config.desktop.gaps;
            gappih = 0;
            gappiv = 0;
            gappoh = config.desktop.gaps;
            gappov = config.desktop.gaps;

            # Color settings
            rootcolor = "0x${base-color}ff";
            bordercolor = "0x${main-color}00";
            focuscolor = "0x${main-color}ff";
            dropcolor = "0x${main-color}80";
            splitcolor = "0x${secondary-color}ff";
            urgentcolor = "0x${urgent-color}ff";

            # Overview colors
            jump_label_decorate_fg_color = "0x${text-color}ff";
            jump_label_decorate_bg_color = "0x${base-color}ff";
            jump_label_decorate_border_color = "0x${main-color}ff";
            jump_label_decorate_border_width = config.desktop.borders;
            jump_label_decorate_corner_radius = config.desktop.corner-radius;

            # Overview settings
            overviewgappi = 5;
            overviewgappo = 50;

            # List of layouts to cycle between with switch_layout
            circle_layout = "scroller,tile,fair";

            # Layout settings
            # Scroller layout
            scroller_structs = 0;
            scroller_default_proportion = 1.0;
            edge_scroller_pointer_focus = 0;
            scroller_proportion_preset = "0.33,0.5,1.0";
            scroller_ignore_proportion_single = 0;

            # Master layout
            new_is_master = 1;
            default_mfact = 0.6;
            default_nmaster = 1;
            center_master_overspread = 0;
            center_when_single_stack = 1;

            # Scratchpad settings
            scratchpad_width_ratio=0.95;
            scratchpad_height_ratio=0.95;
            scratchpadcolor="0x${main-color}ff";

            # tag_num = lib.lists.length config.workspaces;
            tag_num = max_tags_num;

            monitorrule = lib.lists.flatten [
                monitor
            ];

            bind = lib.lists.flatten [
                "ALT,F4,killclient"
                "SUPER+SHIFT,Space,togglefloating"
                "SUPER,f,togglefullscreen"
                "SUPER,s,toggle_scratchpad"
                "SUPER,F2,togglejump"
                "SUPER,r,switch_proportion_preset"
                "SUPER,Up,focusdir,up"
                "SUPER,Down,focusdir,down"
                "SUPER,Left,focusdir,left"
                "SUPER,Right,focusdir,right"
                "SUPER,Prior,focusstack,prev"
                "SUPER,Next,focusstack,next"
                "SUPER+SHIFT,Up,move_client,up"
                "SUPER+SHIFT,Down,move_client,down"
                "SUPER+SHIFT,Left,move_client,left"
                "SUPER+SHIFT,Right,move_client,right"
                monitor_focus
                monitor_move
                "NONE,Print,spawn,${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""
                "SUPER,z,switch_layout"
                "ALT,s,setkeymode,scratchpad"
                "ALT,z,setkeymode,layouts"
                "ALT,x,setkeymode,apps"
                keybinds
                keybinds-multi
            ];

            keymode = {
                apps = {
                    bind = [
                        "NONE,j,spawn,jellyfin-desktop"
                        "NONE,f,spawn,freetube"
                        "NONE,s,spawn,steam"
                        "NONE,Escape,setkeymode,default"
                        "ALT,x,setkeymode,default"
                    ];
                };
                common = {
                    bind = [
                        "SUPER+SHIFT,r,reload_config"
                        "SUPER+SHIFT,e,quit"
                    ];
                };
                layouts = {
                    bind = [
                        "NONE,c,setlayout,center_tile"
                        "NONE,d,setlayout,dwindle"
                        "NONE,f,setlayout,fair"
                        "NONE,m,setlayout,monocle"
                        "NONE,r,setlayout,right_tile"
                        "NONE,s,setlayout,scroller"
                        "NONE,t,setlayout,tile"
                        "SHIFT,f,setlayout,vertical_fair"
                        "SHIFT,s,setlayout,vertical_scroller"
                        "SHIFT,t,setlayout,vertical_tile"
                        "NONE,Escape,setkeymode,default"
                        "ALT,z,setkeymode,default"
                    ];
                };
                position = {
                    mousebind = [
                        "NONE,btn_left,moveresize,curmove"
                        "NONE,btn_right,moveresize,curresize"
                        "NONE,btn_middle,toggleoverview"
                        "NONE,btn_forward,setkeymode,default"
                    ];
                };
                scratchpad = {
                    bind = [
                        "NONE,s,toggle_scratchpad"
                        "NONE,a,minimized"
                        "NONE,d,restore_minimized"
                        "NONE,Escape,setkeymode,default"
                        "ALT,s,setkeymode,default"
                    ];
                };
            };

            mousebind = [
                "SUPER,btn_left,moveresize,curmove"
                "SUPER,btn_right,moveresize,curresize"
                "NONE,btn_forward,setkeymode,position"
            ];

            tagrule = lib.lists.flatten [
                workspaces
            ];

            windowrule = lib.lists.flatten [
                windows
            ];
        };
        systemd = {
            enable = true;
            xdgAutostart = true;
        };
    };
}
