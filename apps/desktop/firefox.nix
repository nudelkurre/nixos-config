{
    pkgs,
    config,
    sharedSettings,
    lib,
    ...
}:
let
    version = sharedSettings.firefox-version;
in
{
    programs.firefox = {
        enable = true;
        package = pkgs.${version};
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
            "DisableProfileRefresh" = false;
            "DisableSetDesktopBackground" = true;
            "DisableSystemAddonUpdate" = true;
            "DisableTelemetry" = true;
            "DisplayBookmarksToolbar" = "newtab";
            "DisplayMenuBar" = "default-off";
            "DNSOverHTTPS" = {
                "Enabled" = true;
                "ProviderURL" = "https://dns.nudelkurre.com/dns-query/computer";
                "Locked" = false;
                "ExcludedDomains" = [ ];
                "Fallback" = false;
            };
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
                "Install" = [
                    "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-11423598-latest.xpi"
                    "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/addon-12533945-latest.xpi"
                    "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/addon-6458157-latest.xpi"
                    "https://addons.mozilla.org/firefox/downloads/latest/floccus/addon-12344312-latest.xpi"
                    "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/addon-4757633-latest.xpi"
                    "https://addons.mozilla.org/firefox/downloads/latest/linkwarden/addon-18125611-latest.xpi"
                ];
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
            "GenerativeAI" = {
                "Enable" = false;
                "Chatbot" = false;
                "LinkPreviews" = false;
                "TabGroups" = false;
                "Locked" = false;
            };
            "HardwareAcceleration" = true;
            "Homepage" = {
                "URL" = "about:home";
                "Locked" = true;
                "StartPage" = "homepage-locked";
            };
            "HttpsOnlyMode" = "force_enabled";
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
                "Locked" = true;
            };
            "PopupBlocking" = {
                "Allow" = [ ];
                "Default" = true;
                "Locked" = true;
            };
            "PostQuantumKeyAgreementEnabled" = true;
            "Preferences" = {
                "browser.aboutConfig.showWarning" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.ai.control.default" = {
                    "Value" = "blocked";
                    "Type" = "string";
                    "Status" = "locked";
                };
                "browser.ai.control.linkPreviewKeyPoints" = {
                    "Value" = "blocked";
                    "Type" = "string";
                    "Status" = "locked";
                };
                "browser.ai.control.pdfjsAltText" = {
                    "Value" = "blocked";
                    "Type" = "string";
                    "Status" = "locked";
                };
                "browser.ai.control.smartTabGroups" = {
                    "Value" = "blocked";
                    "Type" = "string";
                    "Status" = "locked";
                };
                "browser.chrome.site_icons" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.contentblocking.report.hide_vpn_banner" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.display.background_color" = {
                    "Value" = sharedSettings.colors.${sharedSettings.colors.variant}.base;
                    "Type" = "string";
                    "Status" = "default";
                };
                "browser.display.foreground_color" = {
                    "Value" = sharedSettings.colors.${sharedSettings.colors.variant}.text;
                    "Type" = "string";
                    "Status" = "default";
                };
                "browser.fixup.domainsuffixwhitelist.lan" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.ml.chat.enabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "locked";
                };
                "browser.ml.linkPreview.enabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "locked";
                };
                "browser.privatebrowsing.promoEnabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.privatebrowsing.vpnpromourl" = {
                    "Value" = "";
                    "Type" = "string";
                    "Status" = "default";
                };
                "browser.safebrowsing.downloads.remote.enabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.shell.shortcutFavicons" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.urlbar.speculativeConnect.enabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "browser.urlbar.trimURLs" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "media.peerconnection.enabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "network.http.referer.XOriginPolicy" = {
                    "Value" = 0;
                    "Type" = "number";
                    "Status" = "default";
                };
                "network.http.referer.XOriginTrimmingPolicy" = {
                    "Value" = 2;
                    "Type" = "number";
                    "Status" = "default";
                };
                "network.IDN_show_punycode" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "network.predictor.enabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "network.prefetch-next" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "network.security.esni.enabled" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "network.trr.allow-rfc1918" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "places.history.enabled" = {
                    "Value" = false;
                    "Type" = "boolean";
                    "Status" = "default";
                };
                "privacy.userContext.enabled" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "locked";
                };
                "privacy.userContext.ui.enabled" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "locked";
                };
                "toolkit.legacyUserProfileCustomizations.stylesheets" = {
                    "Value" = true;
                    "Type" = "boolean";
                    "Status" = "locked";
                };
            };
            "PromptForDownloadLocation" = true;
            "Proxy" = {
                "Mode" = "none";
                "Locked" = true;
            };
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
            "SearchBar" = "unified";
            "SearchEngines" = {
                "Add" = [
                    {
                        "Name" = "Duckduckgo";
                        "URLTemplate" =
                            "https://duckduckgo.com/?q={searchTerms}&kz=1&kae=d&ks=m&kf=-1&kp=-2&kw=w&ko=s&kaf=1&kac=-1&km=m&kn=1";
                        "Method" = "GET";
                        "Alias" = "@ddg";
                        "Description" = "DuckDuckGo search";
                        "PostData" = "q={searchTerms}&kz=1&kae=d&ks=m&kf=-1&kp=-2&kw=w&ko=s&kaf=1&kac=-1&km=m&kn=1";
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
                        "Name" = "Mangadex";
                        "URLTemplate" = "https://mangadex.org/titles?q={searchTerms}&onlyAvailableChapters=true&translatedLang=en";
                        "Method" = "GET";
                        "IconURL" = "https://mangadex.org/favicon.ico";
                        "Alias" = "@md";
                        "Description" = "Search for manga on mangadex";
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
                    "Perplexity"
                ];
            };
            "SearchSuggestEnabled" = false;
            "ShowHomeButton" = false;
            "SkipTermsOfUse" = true;
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
                    Hotmail = {
                        color = "blue";
                        icon = "chill";
                        id = 7;
                    };
                    Twitter = {
                        color = "blue";
                        icon = "vacation";
                        id = 8;
                    };
                    Facebook = {
                        color = "blue";
                        icon = "fingerprint";
                        id = 9;
                    };
                    Personal = {
                        color = "blue";
                        icon = "fingerprint";
                        id = 10;
                    };
                    "Yt music" = {
                        color = "red";
                        icon = "circle";
                        id = 11;
                    };
                    Proxy = {
                        color = "pink";
                        icon = "circle";
                        id = 12;
                    };
                    Blusky = {
                        color = "blue";
                        icon = "circle";
                        id = 13;
                    };
                };
                containersForce = true;
                id = 0;
                isDefault = true;
                settings = {
                    "beacon.enabled" = false;
                    "font.name-list.emoji" = "${toString (
                        lib.lists.sublist 0 1 config.fonts.fontconfig.defaultFonts.emoji
                    )}";
                    "privacy.history.custom" = true;
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

                    .subviewbutton, .urlbar {
                        font-size: ${toString config.fonts.size}px;
                    }
                '';
            };
        };
    };
    xdg.desktopEntries = lib.mkIf config.programs.firefox.enable {
        "${version}" = {
            actions = {
                "new-private-window" = {
                    exec = "${version} --private-window %U";
                    name = "New Private Window";
                };
                "profile-manager-window" = {
                    exec = "${version} --ProfileManager";
                    name = "Profile Manager";
                };
            };
            categories = [
                "Network"
                "WebBrowser"
            ];
            exec = "${version} --new-window %U";
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
            name = "${version}";
            # noDisplay = true;
            startupNotify = true;
            terminal = false;
            type = "Application";
        };
    };
}
