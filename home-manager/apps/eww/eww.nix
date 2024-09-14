{pkgs, config, lib, ...}:
with lib;
let
    cfg = config.eww;

    styles = "
        $startColor: ${cfg.secondary-color};
        $mainColor: ${cfg.main-color};
        $text-color: ${cfg.text-color};
        $font: '${config.fonts.name}';
        $font-size: ${toString config.fonts.size}px;
        $icon-font: '${cfg.icon-font}';
        $icon-size: ${toString cfg.icon-size}px;
        $icon-glow: 0 0 4px rgb(200, 255, 255);
        $background-linear: linear-gradient(0deg, $startColor, $mainColor);
        $margins: 0px 4px 0px 4px;
        $paddings: 2px 15px 2px 15px;
        $radius: 50px 50px 50px 50px;
        $workspace-padding: 0px 0px;

        window {
            background: rgba(0,0,0,0);
            font-size: $font-size;
            font-weight: 700;
            font-family: $font;
        }

        .bar-box {
            background: rgba(0, 0, 0, 0.25);
        }

        .workspace-bar, .widgets-box {
            background-image: $background-linear;
            color: $text-color;
            padding: $paddings;
            margin: $margins;
            border-radius: $radius;
        }

        .icons {
            font-family: $icon-font;
            font-size: $icon-size;
            margin-right: 10px;
            text-shadow: $icon-glow;
        }

        .workspace {
            padding: $workspace-padding;
            font-family: $icon-font;
            font-size: $icon-size;
        }

        .active {
            color: $text-color;
            text-shadow: $icon-glow;
        }

        .inactive {
            color: darken($text-color, 30%);
        }

        .widget-box {
            background: rgba(0,0,0,0.5);
            color: $text-color;
            border-radius: 30px;
        }

        .widgets {
            padding: 15px 30px 15px 30px;
        }

        .widgeticons {
            font-size: 70px;
        }

        .power-widget {
            background: cyan;
            padding: 10px 0px 10px 0px;
        }

        .button {
            background: rgb(100, 100, 100);
            color: rgb(51, 51, 51);
            padding: 30px;
            margin: 5px;
            border-radius: 20px;
            font-size: 50px;
        }

        .button:hover {
            color: white;
        }

        .button:active {
            border-color: green;
            border-width: 0px;
            color: rgb(51, 51, 51);
            background: rgb(75, 75, 75);
        }
    ";

    scripts = [
        "(deflisten wsdata :initial \"null\" `${pkgs.scripts.workspaces}/bin/workspaces`)"
        "(deflisten volume-info :initial \"null\" `${pkgs.scripts.volume}/bin/volume`)"
        "(deflisten diskinfo :initial \"null\" `${pkgs.scripts.disk}/bin/disk`)"
        "(deflisten netinfo :initial \"null\" `${pkgs.scripts.network}/bin/network`)"
        "(deflisten bluetooth :initial \"{}\" `${pkgs.scripts.bluetooth}/bin/bluetooth --show-disconnected`)"
        "(deflisten weatherinfo :initial '{\"status\": \"failed\"}' `${pkgs.scripts.weather}/bin/weather Västerås`)"
        "(defpoll headset-level :initial \"0\" :interval \"5s\" `headsetcontrol -bc`)"
    ];

    widget_windows = builtins.map
        (w:
            "(defwindow ${w.name}
                :monitor ${toString w.id}
                :geometry (geometry
                                :x \"${toString w.x}\"
                                :y \"${toString w.y}\"
                                ${if w.width > 0 then ":width \"${toString w.width}%\"" else ""}
                                ${if w.height > 0 then ":height \"${toString w.height}%\"" else ""}
                                :anchor \"${w.anchor}\"
                            )
                :stacking \"bottom\"
                :exclusive false
                :namespace \"widget\"
                (${w.name}_widget)
            )
            "
        )
        (cfg.widgets);

    windows_options = builtins.map
        (w:
            "(defwindow ${w.name}
                :monitor ${toString w.id}
                :geometry (geometry
                                :x \"0\"
                                :y \"0\"
                                :width \"${toString w.width}\"
                                :anchor \"top center\"
                            )
                :stacking \"fg\"
                :exclusive true
                :namespace \"bar\"
                (${w.name}-bar)
            )
            "
        )
        (cfg.bars);

    widget = builtins.map
        (w:
        let
            modules = lib.strings.concatStringsSep "\n" w.modules;
        in
        "(defwidget ${w.name}_widget []
            (box :class \"widget-box\" :orientation \"v\" :space-evenly false
                ${modules}
            )
        )"
        )
        (cfg.widgets);

    bars_options = builtins.map 
        (b:
            let
                modules = lib.strings.concatStringsSep "\n" b.widgets;
            in
            "(defwidget ${b.name}-bar []
                (box :class \"bar-box\" :space-evenly false
                    ${modules}
                )
            )
            "
        )
        (cfg.bars);

    widget_modules = [
        "(defwidget net [interface]
            (box :class {netinfo?.['$\{interface}'] != \"null\" && netinfo?.['$\{interface}']?.connection == \"connected\" ? \"widgets-box\" : \"empty\"} :space-evenly false
                (box :class {netinfo?.['$\{interface}'] != \"null\" && netinfo?.['$\{interface}']?.connection == \"connected\" ? \"icons\" : \"\"} {netinfo?.['$\{interface}']?.connection == \"connected\" ? \"󰈀\" : \"\"})
                (label :text {netinfo?.['$\{interface}']?.connection == \"connected\" && netinfo?.['$\{interface}']?.ip != \"\" ? \"$\{netinfo?.['$\{interface}']?.ip}\" : \"\"})
            )
        )"

        "(defwidget disk [mountpoint]
            (tooltip
                (label :text {diskinfo?.['$\{mountpoint}'] != \"null\" ? \"$\{mountpoint} $\{diskinfo?.['$\{mountpoint}']?.fsused}iB/$\{diskinfo?.['$\{mountpoint}']?.fssize}iB\" : \"\"})
                (box :class {diskinfo?.['$\{mountpoint}'] != \"null\" ? \"widgets-box\" : \"\"} :space-evenly false 
                    (box :class {diskinfo?.['$\{mountpoint}'] != \"null\" ? \"icons\" : \"\"} {diskinfo?.['$\{mountpoint}'] != \"null\" ? \"\" : \"\"})
                    (label :text {diskinfo?.['$\{mountpoint}'] != \"null\" ? \"$\{diskinfo?.['$\{mountpoint}']?.fsuse_pct}\" : \"\"})
                )
            )
        )"

        "(defwidget workspace [monitor]
            (eventbox :onscroll `${pkgs.scripts.workspaces}/bin/workspaces --change_workspace {}`
                (box :class {wsdata?.[monitor] != \"null\" ? \"workspace-bar\" : \"\"}
                    (for w in {wsdata?.[monitor] != \"null\" ? wsdata[monitor] : []}
                        (eventbox :onclick `${pkgs.scripts.workspaces}/bin/workspaces --goto_workspace $\{w['id']}`
                            (box :class {w['active'] ? \"workspace active\" : \"workspace inactive\"} \"$\{w['name']} \")
                        )
                    )
                )
            )
        )"

        "(defwidget volume []
            (eventbox
                    :onclick `${pkgs.scripts.volume}/bin/volume --mute`
                    :onrightclick `${pkgs.scripts.volume}/bin/volume --change_default`
                    :onscroll `${pkgs.scripts.volume}/bin/volume --change_volume {}`
                (box :class {volume-info == \"null\" ? \"\" : \"widgets-box\"} :space-evenly false 
                    (tooltip
                        (label :text {volume-info == \"null\" ? \"\" : \"$\{volume-info?.name}\"})
                        (box
                            (box :class {volume-info == \"null\" ? \"\" : \"icons\"} {volume-info == \"null\" ? \"\" : \"$\{volume-info?.icon}\"})
                            (label :text {volume-info == \"null\" ? \"\" : \"$\{volume-info?.volume}\"})
                        )
                    )
                )
            )
        )"

        "(defwidget cpu []
            (box :class \"widgets-box\" :space-evenly false 
                (box :class \"icons\" \"\")
                (label :text \"$\{round(EWW_CPU.avg, 0)}%\")
            )
        )"

        "(defwidget weather [iconsize]
            (box :class {weatherinfo?.status == \"ok\" ? \"widgets-box\" : \"\"} :space-evenly false
                (image :class \"icons\" :image-width iconsize :image-height iconsize :path {weatherinfo?.status == \"ok\" ? \"$\{EWW_CONFIG_DIR}/$\{weatherinfo.weather-info.icon}\" : \"$\{EWW_CONFIG_DIR}/images/icons/weather/day/1.svg\"})
                (label :text {weatherinfo?.status == \"ok\" ? \"$\{weatherinfo.weather-info.temp}°C\" : \"\"})
            )
        )"

        "(defwidget time [tz]
            (tooltip
                (box :space-evenly false
                    (label :class \"icons\" :text \"\")
                    (label :text \"$\{formattime(EWW_TIME, \"%A %Y-%m-%d\", tz)}\")
                )
                (box :class \"widgets-box\" :space-evenly false
                    (label :class \"icons\" :text \"\")
                    (label :text \"$\{formattime(EWW_TIME, \"%H:%M:%S %Z\", tz)}\")
                )
            )
        )"

        "(defwidget bt []
            (box :space-evenly false
                (for device in {jq(bluetooth, 'keys')}
                    (box :class {bluetooth[device][\"connected\"] == \"yes\" ? \"widgets-box\" : \"\"}
                        (tooltip
                            (label :text {bluetooth[device][\"connected\"] == \"yes\" ? \"\$\{bluetooth[device]['name']}\" : \"\"})
                            (box
                                (label :class {bluetooth[device][\"connected\"] == \"yes\" ? \"icons\" : \"\"} :text {bluetooth[device][\"connected\"] == \"yes\" ? \"\$\{bluetooth[device]['icon']}\" : \"\"})
                                (label :text {bluetooth[device][\"connected\"] == \"yes\" ? \"\$\{bluetooth[device]['battery_level']}\" : \"\"})
                            )
                        )
                    )
                )
            )
        )"

        "(defwidget weather-widget [iconsize]
            (box :class \"widgets\" :space-evenly true
                (box :orientation \"v\" :space-evenly false
                    (image :class \"widgeticons\" :image-width iconsize :image-height iconsize :path {weatherinfo?.status == \"ok\" ? \"$\{EWW_CONFIG_DIR}/$\{weatherinfo.weather-info.icon}\" : \"$\{EWW_CONFIG_DIR}/images/icons/weather/day/1.svg\"})
                    (box :class \"widgettext\" {weatherinfo?.status == \"ok\" ? \"$\{weatherinfo.weather-info.description}\" : \"\"})
                )
                (box :orientation \"v\" :space-evenly true
                    (box :class \"widgettext\" {weatherinfo?.status == \"ok\" ? \"Temperature $\{weatherinfo.weather-info.temp} °C\" : \"\"})
                    (box :class \"widgettext\" {weatherinfo?.status == \"ok\" ? \"Wind speed $\{weatherinfo.weather-info.windspeed} m/s\" : \"\"})
                    (box :class \"widgettext\" {weatherinfo?.status == \"ok\" ? \"Sunrise $\{weatherinfo.sun.rise}\" : \"\"})
                    (box :class \"widgettext\" {weatherinfo?.status == \"ok\" ? \"Sunset $\{weatherinfo.sun.set}\" : \"\"})
                )
            )
        )"

        "(defwidget headset []
            (box :class {headset-level > \"0\" && headset-level <= \"100\" ? \"widgets-box\" : \"\"} {headset-level > \"0\" && headset-level <= \"100\" ? \"$\{headset-level}%\" : \"\"})
        )"

        "(defwidget spacer []
            (box :class \"spacer-box\" :hexpand true :vexpand true)
        )"

        "(defwidget tray []
            (systray :class \"widgets-box\" :icon-size ${toString cfg.icon-size} :space-evenly false)
        )"
    ];
in
{
    config = mkIf config.eww.enable {
        home.packages = [ cfg.package ];

        xdg.configFile."eww/eww.scss".text = styles;

        xdg.configFile."eww/images".source = ./images;


        xdg.configFile."eww/eww.yuck".text = ''
        (include "./testing.yuck")
${lib.strings.concatStringsSep "\n" scripts}

${lib.strings.concatStringsSep "\n" bars_options}

${lib.strings.concatStringsSep "\n" widget}

${lib.strings.concatStringsSep "\n" windows_options}

${lib.strings.concatStringsSep "\n" widget_windows}

${lib.strings.concatStringsSep "\n" widget_modules}
            '';
    };
}