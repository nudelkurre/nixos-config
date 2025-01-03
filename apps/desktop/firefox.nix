{pkgs, config, lib, inputs, firefox-addons, ...}:
{
    programs.firefox = {
        enable = true;
        package = pkgs.firefox-esr;
        policies = {
            "CaptivePortal" = false;
            "Cookies" = {
                "Behavior" = "reject-foreign";
                "BehaviorPrivateBrowsing" = "reject-foreign";
                "Locked" = true;
                "RejectTracker" = true;
            };
            "DisableFirefoxAccounts" = true;
            "DisableFirefoxStudies" = true;
            "DisableMasterPasswordCreation" = true;
            "DisablePocket" = true;
            "DisableSecurityBypass" = {
                "InvalidCertificate" = false;
                "SafeBrowsing" = false;
            };
            "DisableTelemetry" = true;
            "DownloadDirectory" = "${config.home.homeDirectory}/Downloads";
            "EnableTrackingProtection" = {
                "Value" = true;
                "Locked" = true;
                "Cryptomining" = true;
                "Fingerprinting" = true;
                "Exceptions" = [];
            };
            "FirefoxHome" = {
                "Search" = true;
                "TopSites" = false;
                "SponsoredTopSites" = false;
                "Highlights" = false;
                "Pocket" = false;
                "SponsoredPocket" = false;
                "Snippets" = false;
                "Locked" = true;
            };
            "Homepage" = {
                "Locked" = true;
                "StartPage" = "homepage-locked";
            };
            "NetworkPrediction" = false;
            "NewTabPage" = true;
            "NoDefaultBookmarks" = true;
            "OfferToSaveLogins" = false;
            "OfferToSaveLoginsDefault" = false;
            "PasswordManagerEnabled" = false;
            "Permissions" = {
                "Camera" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Microphone" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Location" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Notifications" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "Autoplay" = {
                    "Allow" = ["https://www.twitch.tv" "https://clips.twitch.tv"];
                    "Block" = [];
                    "Default" = "block-audio-video";
                    "BlockNewRequests" = true;
                    "Locked" = false;
                };
                "VirtualReality" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = true;
                };
            };
            "PictureInPicture" = {
                "Enabled" = false;
                "Locked" = false;
            };
            "PopupBlocking" = {
                "Allow" = [];
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
                "Remove" = ["Google" "Amazon" "Bing" "Wikipedia"];
            };
            "TranslateEnabled" = false;
            "UserMessaging" = {
                "WhatsNew" = false;
                "ExtensionRecommendations" = false;
                "FeatureRecommendations" = false;
                "UrlbarInterventions" = false;
                "SkipOnboarding" = false;
                "MoreFromMozilla" = false;
                "Locked" = true;
            };
        };
        profiles = {
            "Default-lw" = {
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
                extensions = with pkgs.firefox-addons; [
                    ublock-origin
                    bitwarden
                    violentmonkey
                    floccus
                    sponsorblock
                    multi-account-containers
                ];
                id = 0;
                isDefault = true;
                search = {
                    default = "DuckDuckGo";
                    force = true;
                };
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
                    "browser.toolbars.bookmarks.visibility" = "always";
                    "browser.urlbar.speculativeConnect.enabled" = false;
                    "browser.urlbar.trimURLs" = false;
                    "dom.event.clipboardevents.enabled" = false;
                    "extensions.pocket.enabled" = false;
                    "font.name-list.emoji" = "${toString (lib.lists.sublist 0 1 config.fonts.fontconfig.defaultFonts.emoji)}";
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
        "firefox-esr-private" = {
            categories = [ "Network" "WebBrowser" ];
            exec = "${config.programs.firefox.package}/bin/firefox-esr --private-window %U";
            genericName = "Web Browser";
            icon = "firefox-esr";
            mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
            name = "Firefox ESR Private Window";
            noDisplay = true;
            terminal = false;
        };
    };
}
