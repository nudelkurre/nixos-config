{
    pkgs,
    config,
    lib,
    ...
}:
{
    programs.firefox = {
        enable = true;
        package = pkgs.firefox;
        policies = {
            "CaptivePortal" = false;
            "Cookies" = {
                "Behavior" = "reject-foreign";
                "BehaviorPrivateBrowsing" = "reject-foreign";
                "Locked" = true;
            };
            "DisableFirefoxAccounts" = true;
            "DisableFirefoxStudies" = true;
            "DisableFormHistory" = true;
            "DisableMasterPasswordCreation" = true;
            "DisablePasswordReveal" = true;
            "DisableSetDesktopBackground" = true;
            "DisableSystemAddonUpdate" = true;
            "DisableTelemetry" = true;
            "DontCheckDefaultBrowser" = true;
            "DownloadDirectory" = "${config.home.homeDirectory}/Downloads";
            "EnableTrackingProtection" = {
                "Value" = true;
                "Locked" = true;
                "Cryptomining" = true;
                "Fingerprinting" = true;
                "EmailTracking" = true;
                "Exceptions" = [ ];
            };
            "EncryptedMediaExtensions" = {
                "Enabled" = false;
                "Locked" = true;
            };
            "Extensions" = {
                "Install" = [ ];
                "Uninstall" = [
                    "amazon@search.mozilla.org"
                    "bing@search.mozilla.org"
                    "google@search.mozilla.org"
                    "wikipedia@search.mozilla.org"
                ];
                "Locked" = [
                    "{446900e4-71c2-419f-a6a7-df9c091e268b}"
                    "@testpilot-containers"
                    "floccus@handmadeideas.org"
                    "uBlock0@raymondhill.net"
                    "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}"
                    "jordanlinkwarden@gmail.com"
                ];
            };
            "FirefoxHome" = {
                "Search" = true;
                "TopSites" = false;
                "SponsoredTopSites" = false;
                "Highlights" = false;
                "Pocket" = false;
                "Stories" = false;
                "SponsoredPocket" = false;
                "SponsoredStories" = false;
                "Snippets" = false;
                "Locked" = true;
            };
            "Homepage" = {
                "URL" = "about:home";
                "Locked" = true;
                "StartPage" = "homepage-locked";
            };
            "HttpsOnlyMode" = "force_enabled";
            "InstallAddonsPermission" = {
                "Default" = false;
            };
            "NetworkPrediction" = false;
            "NewTabPage" = true;
            "NoDefaultBookmarks" = true;
            "OfferToSaveLogins" = false;
            "OverrideFirstRunPage" = "";
            "OverridePostUpdatePage" = "";
            "PasswordManagerEnabled" = false;
            "Permissions" = {
                "Camera" = {
                    "Allow" = [ ];
                    "Block" = [ ];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Microphone" = {
                    "Allow" = [ ];
                    "Block" = [ ];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Location" = {
                    "Allow" = [ ];
                    "Block" = [ ];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Notifications" = {
                    "Allow" = [ ];
                    "Block" = [ ];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Autoplay" = {
                    "Allow" = [
                        "https://www.twitch.tv"
                        "https://clips.twitch.tv"
                    ];
                    "Block" = [ ];
                    "Default" = "block-audio-video";
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "VirtualReality" = {
                    "Allow" = [ ];
                    "Block" = [ ];
                    "BlockNewRequests" = true;
                    "Locked" = true;
                };
            };
            "PictureInPicture" = {
                "Enabled" = false;
                "Locked" = false;
            };
            "PopupBlocking" = {
                "Allow" = [ ];
                "Default" = true;
                "Locked" = true;
            };
            "Preferences" = {
                "toolkit.legacyUserProfileCustomizations.stylesheets" = {
                    "Value" = true;
                    "Status" = "locked";
                };
                "browser.fixup.domainsuffixwhitelist.lan" = {
                    "Value" = true;
                    "Status" = "default";
                };
                "browser.ml.enabled" = {
                    "Value" = false;
                    "Status" = "locked";
                };
                "browser.ml.chat.enabled" = {
                    "Value" = false;
                    "Status" = "locked";
                };
                "extensions.ml.enabled" = {
                    "Value" = false;
                    "Status" = "locked";
                };
            };
            "PromptForDownloadLocation" = true;
            "SanitizeOnShutdown" = {
                "Cache" = true;
                "Cookies" = false;
                "Downloads" = true;
                "FormData" = true;
                "History" = true;
                "Sessions" = false;
                "SiteSettings" = false;
                "OfflineApps" = false;
                "Locked" = true;
            };
            "SearchEngines" = {
                "Add" = [
                    {
                        "Name" = "Duckduckgo";
                        "URLTemplate" = "https://duckduckgo.com/?q={searchTerms}&kz=1&kae=d&ks=m&kf=-1&kp=-2&kw=w&ko=1&kaf=1&kac=-1&km=m&kn=1";
                        "Method" = "GET";
                        "Alias" = "@ddg";
                        "Description" = "DuckDuckGo search";
                        "PostData" = "q={searchTerms}&kz=1&kae=d&ks=m&kf=-1&kp=-2&kw=w&ko=1&kaf=1&kac=-1&km=m&kn=1";
                        "IconURL" = "https://duckduckgo.com/favicon.ico";
                    }
                    {
                        "Name" = "Gog";
                        "URLTemplate" = "https://www.gog.com/en/games?query={searchTerms}&hideDLCs=true";
                        "Method" = "GET";
                        "IconURL" = "https://store-static-modular.gog-statics.com/en/assets/favicons/favicon.ico";
                        "Alias" = "@gog";
                        "Description" = "Gog store";
                    }
                    {
                        "Name" = "HowLongToBeat";
                        "URLTemplate" = "https://howlongtobeat.com/?q={searchTerms}";
                        "Method" = "GET";
                        "IconURL" = "https://howlongtobeat.com/img/icons/favicon-16x16.png";
                        "Alias" = "@hltb";
                        "Description" = "Search for time to beat a game";
                    }
                    {
                        "Name" = "Nixos options";
                        "URLTemplate" = "https://search.nixos.org/options?query={searchTerms}";
                        "Method" = "GET";
                        "IconURL" = "https://search.nixos.org/favicon.png";
                        "Alias" = "@no";
                        "Description" = "Search for nixos options";
                    }
                    {
                        "Name" = "Nixos packages";
                        "URLTemplate" = "https://search.nixos.org/packages?query={searchTerms}";
                        "Method" = "GET";
                        "IconURL" = "https://search.nixos.org/favicon.png";
                        "Alias" = "@np";
                        "Description" = "Search for nixos packages";
                    }
                    {
                        "Name" = "Startpage";
                        "URLTemplate" = "https://www.startpage.com/sp/search?query={searchTerms}";
                        "Method" = "GET";
                        "IconURL" = "https://www.startpage.com/sp/cdn/favicons/favicon-16x16-gradient.png";
                        "Alias" = "@sp";
                        "Description" = "Startpage search";
                        "PostData" = "query={searchTerms}";
                        "SuggestURLTemplate" = "https://www.startpage.com/osuggestions?q={searchTerms}";
                    }
                    {
                        "Name" = "Steam";
                        "URLTemplate" = "https://store.steampowered.com/search/?term={searchTerms}";
                        "Method" = "GET";
                        "IconURL" = "https://store.steampowered.com/favicon.ico";
                        "Alias" = "@steam";
                        "Description" = "Steam store";
                    }

                ];
                "Default" = "Duckduckgo";
                "PreventInstalls" = true;
                "Remove" = [
                    "DuckDuckGo"
                    "Google"
                    "Amazon"
                    "Bing"
                    "Wikipedia (en)"
                    "Ecosia"
                ];
            };
            "TranslateEnabled" = false;
            "UserMessaging" = {
                "WhatsNew" = false;
                "ExtensionRecommendations" = false;
                "FeatureRecommendations" = false;
                "UrlbarInterventions" = false;
                "SkipOnboarding" = false;
                "MoreFromMozilla" = false;
                "FirefoxLabs" = false;
                "Locked" = true;
            };
        };
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
                settings = {
                    "beacon.enabled" = false;
                    "browser.aboutConfig.showWarning" = false;
                    "browser.chrome.site_icons" = false;
                    "browser.contentblocking.category" = "custom";
                    "browser.contentblocking.report.hide_vpn_banner" = true;
                    "browser.display.background_color" = "#e2e2e2";
                    "browser.display.foreground_color" = "#4a4a4a";
                    "browser.formfill.enable" = false;
                    "browser.privatebrowsing.promoEnabled" = false;
                    "browser.privatebrowsing.vpnpromourl" = "";
                    "browser.safebrowsing.downloads.remote.enabled" = false;
                    "browser.search.suggest.enabled" = false;
                    "browser.shell.shortcutFavicons" = false;
                    "browser.toolbars.bookmarks.visibility" = "newtab";
                    "browser.urlbar.speculativeConnect.enabled" = false;
                    "browser.urlbar.trimURLs" = false;
                    "dom.event.clipboardevents.enabled" = false;
                    "extensions.pocket.enabled" = false;
                    "font.name-list.emoji" = "${toString (
                        lib.lists.sublist 0 1 config.fonts.fontconfig.defaultFonts.emoji
                    )}";
                    "general.warnOnAboutConfig" = false;
                    "geo.enabled" = false;
                    "identity.fxaccounts.enabled" = false;
                    "media.peerconnection.enabled" = false;
                    "network.cookie.cookieBehavior" = 1;
                    "network.dns.disablePrefetch" = true;
                    "network.http.referer.XOriginPolicy" = 1;
                    "network.http.referer.XOriginTrimmingPolicy" = 2;
                    "network.IDN_show_punycode" = true;
                    "network.predictor.enabled" = false;
                    "network.prefetch-next" = false;
                    "network.security.esni.enabled" = true;
                    "places.history.enabled" = false;
                    "privacy.history.custom" = true;
                    "privacy.userContext.enabled" = true;
                    "privacy.userContext.ui.enabled" = true;
                    "toolkit.telemetry.enabled" = false;
                    "toolkit.telemetry.prompted" = 2;
                    "toolkit.telemetry.rejected" = true;
                    "toolkit.telemetry.server" = "";
                    "toolkit.telemetry.unified" = false;
                    "toolkit.telemetry.unifiedIsOptIn" = false;
                };
                userChrome = ''
                    #alltabs-button {
                        display: none;
                    }

                    .tab-context-line {
                        width: 100% !important;
                        height: 100% !important;
                        background-color: color-mix(in srgb, var(--identity-icon-color) 30%, transparent) !important;
                        margin: 0 !important;
                    }

                    .tab-icon-overlay {
                        opacity: unset !important;
                    }

                    .tab-secondary-label {
                        display: none;
                    }

                    .titlebar-buttonbox {
                        display: none;
                    }

                    .wrapper {
                        padding: 0px 0px !important;;
                    }

                    #sidebar-main {
                        margin-left: -8px !important;
                        margin-right: -8px !important;
                        margin-top: 0px !important;
                        margin-bottom: 0px !important;
                    }

                    #sidebar-button {
                        display: none;
                    }
                '';
            };
        };
    };
    xdg.desktopEntries = {
        "firefox-private" = {
            categories = [
                "Network"
                "WebBrowser"
            ];
            exec = "${config.programs.firefox.package}/bin/firefox --private-window %U";
            genericName = "Web Browser";
            icon = "firefox";
            mimeType = [
                "text/html"
                "text/xml"
                "application/xhtml+xml"
                "application/vnd.mozilla.xul+xml"
                "x-scheme-handler/http"
                "x-scheme-handler/https"
            ];
            name = "Firefox Private Window";
            noDisplay = true;
            terminal = false;
        };
    };
}
