{ pkgs, config, ... }:
{
    programs.floorp = {
        enable = true;
        package = pkgs.unstable.floorp;
        profiles = {
            "Default" = {
                containers = {
                    Twitch = {
                        color = "purple";
                        icon = "chill";
                        id = 1;
                    };
                    "Twitch (no login)" = {
                        color = "turquoise";
                        icon = "chill";
                        id = 2;
                    };
                    Selfhosted = {
                        color = "pink";
                        icon = "fingerprint";
                        id = 3;
                    };
                    TryHackMe = {
                        color = "green";
                        icon = "briefcase";
                        id = 4;
                    };
                    Socials = {
                        color = "red";
                        icon = "fingerprint";
                        id = 5;
                    };
                    Youtube = {
                        color = "red";
                        icon = "chill";
                        id = 6;
                    };
                    Linkedin = {
                        color = "blue";
                        icon = "chill";
                        id = 7;
                    };
                    Hotmail = {
                        color = "blue";
                        icon = "chill";
                        id = 8;
                    };
                    Facebook = {
                        color = "blue";
                        icon = "fingerprint";
                        id = 9;
                    };
                    Crypto = {
                        color = "yellow";
                        icon = "dollar";
                        id = 10;
                    };
                    Personal = {
                        color = "blue";
                        icon = "fingerprint";
                        id = 11;
                    };
                    "Yt music" = {
                        color = "red";
                        icon = "circle";
                        id = 12;
                    };
                    Twitter = {
                        color = "blue";
                        icon = "vacation";
                        id = 13;
                    };
                    Tailscale = {
                        color = "blue";
                        icon = "vacation";
                        id = 14;
                    };
                    Proxy = {
                        color = "pink";
                        icon = "circle";
                        id = 15;
                    };
                    Blusky = {
                        color = "blue";
                        icon = "circle";
                        id = 16;
                    };
                };
                containersForce = true;
                extensions = {
                    packages = with pkgs.firefox-addons; [
                        ublock-origin
                        bitwarden
                        violentmonkey
                        floccus
                        multi-account-containers
                    ];
                };
                id = 0;
                isDefault = true;
                search = {
                    default = "Startpage ";
                    engines = {
                        "DuckDuckGo " = {
                            definedAliases = [ "@ddg" ];
                            description = "DuckDuckGo search";
                            icon = "https://duckduckgo.com/favicon.ico";
                            urls = [
                                {
                                    method = "POST";
                                    params = [
                                        {
                                            name = "q";
                                            value = "{searchTerms}";
                                        }
                                        {
                                            name = "kz";
                                            value = "1";
                                        }
                                        {
                                            name = "kae";
                                            value = "d";
                                        }
                                        {
                                            name = "ks";
                                            value = "m";
                                        }
                                        {
                                            name = "kf";
                                            value = "-1";
                                        }
                                        {
                                            name = "kp";
                                            value = "-2";
                                        }
                                        {
                                            name = "kw";
                                            value = "s";
                                        }
                                        {
                                            name = "ko";
                                            value = "1";
                                        }
                                        {
                                            name = "kaf";
                                            value = "1";
                                        }
                                        {
                                            name = "kac";
                                            value = "-1";
                                        }
                                        {
                                            name = "km";
                                            value = "l";
                                        }
                                    ];
                                    template = "https://duckduckgo.com/";
                                }
                            ];
                        };
                        "Gog" = {
                            definedAliases = [ "@gog" ];
                            description = "Gog store";
                            icon = "https://store-static-modular.gog-statics.com/en/assets/favicons/favicon.ico";
                            urls = [
                                {
                                    method = "GET";
                                    params = [
                                        {
                                            name = "query";
                                            value = "{searchTerms}";
                                        }
                                        {
                                            name = "hideDLCs";
                                            value = "true";
                                        }
                                    ];
                                    template = "https://www.gog.com/en/games";
                                }
                            ];
                        };
                        "HowLongToBeat" = {
                            definedAliases = [ "@hltb" ];
                            description = "Search for time to beat a game";
                            icon = "https://howlongtobeat.com/img/icons/favicon-16x16.png";
                            urls = [
                                {
                                    method = "GET";
                                    params = [
                                        {
                                            name = "q";
                                            value = "{searchTerms}";
                                        }
                                    ];
                                    template = "https://howlongtobeat.com/";
                                }
                            ];
                        };
                        "Nixos Options" = {
                            definedAliases = [ "@no" ];
                            description = "Search for nixos options";
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            urls = [
                                {
                                    method = "GET";
                                    params = [
                                        {
                                            name = "query";
                                            value = "{searchTerms}";
                                        }
                                    ];
                                    template = "https://search.nixos.org/options";
                                }
                            ];
                        };
                        "Nixos Packages" = {
                            definedAliases = [ "@np" ];
                            description = "Search for nixos packages";
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            urls = [
                                {
                                    method = "GET";
                                    params = [
                                        {
                                            name = "query";
                                            value = "{searchTerms}";
                                        }
                                    ];
                                    template = "https://search.nixos.org/packages";
                                }
                            ];
                        };
                        "Startpage " = {
                            definedAliases = [ "@sp" ];
                            description = "Startpage search";
                            icon = "https://www.startpage.com/sp/cdn/favicons/favicon-16x16-gradient.png";
                            urls = [
                                {
                                    method = "POST";
                                    params = [
                                        {
                                            name = "query";
                                            value = "{searchTerms}";
                                        }
                                    ];
                                    template = "https://www.startpage.com/sp/search";
                                }
                            ];
                        };
                        "Steam" = {
                            definedAliases = [ "@steam" ];
                            description = "Steam store";
                            icon = "https://store.steampowered.com/favicon.ico";
                            urls = [
                                {
                                    method = "GET";
                                    params = [
                                        {
                                            name = "term";
                                            value = "{searchTerms}";
                                        }
                                    ];
                                    template = "https://store.steampowered.com/search/";
                                }
                            ];
                        };
                    };
                    force = true;
                    order = [
                        "DuckDuckGo "
                        "Gog"
                        "HowLongToBeat"
                        "Nixos Options"
                        "Nixos Packages"
                        "Startpage "
                        "Steam"
                    ];
                    privateDefault = "Startpage ";
                };
                userChrome = ''
                    #alltabs-button {
                        display: none;
                    }

                    .tab-context-line {
                        width: 100%;
                        height: 100% !important;
                        background-color: color-mix(in srgb, var(--identity-icon-color) 30%, transparent) !important;
                        margin: 0 !important;
                    }

                    .tab-icon-overlay {
                        opacity: unset !important;
                        width: 20px !important;
                        height: 20px !important;
                    }

                    .tab-secondary-label {
                        display: none;
                    }

                    .titlebar-buttonbox {
                        display: none;
                    }
                '';
            };
        };
    };
    xdg.desktopEntries = {
        "floorp-private" = {
            categories = [
                "Network"
                "WebBrowser"
            ];
            exec = "${config.programs.floorp.package}/bin/floorp --private-window %U";
            genericName = "Web Browser";
            icon = "floorp";
            mimeType = [
                "text/html"
                "text/xml"
                "application/xhtml+xml"
                "application/vnd.mozilla.xul+xml"
                "x-scheme-handler/http"
                "x-scheme-handler/https"
            ];
            name = "Floorp Private Window";
            noDisplay = true;
            terminal = false;
        };
    };
}
