{pkgs, config, lib, inputs, firefox-addons, ...}:
{
    programs.firefox = {
        enable = true;
        package = pkgs.firefox-esr-128;
        profiles = {
            "Default-lw" = {
                isDefault = true;
                id = 0;
                search = {
                    default = "DuckDuckGo";
                    force = true;
                };
                extensions = with pkgs.firefox-addons; [
                    ublock-origin
                    bitwarden
                    violentmonkey
                    floccus
                    sponsorblock
                    multi-account-containers
                ];
                containersForce = true;
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
                    "network.IDN_show_punycode" = true;
                    "network.cookie.cookieBehavior" = 1;
                    "network.dns.disablePrefetch" = true;
                    "network.http.referer.XOriginPolicy" = 1;
                    "network.http.referer.XOriginTrimmingPolicy" = 2;
                    "network.predictor.enabled" = false;
                    "network.prefetch-next" = false;
                    "network.security.esni.enabled" = true;
                    "places.history.enabled" = false;
                    "privacy.history.custom" = true;
                    "privacy.userContext.enabled" = true;
                    "privacy.userContext.ui.enabled" = true;
                    "toolkit.telemetry.enabled" = false;
                    "toolkit.telemetry.rejected" = true;
                    "toolkit.telemetry.server" = "";
                    "toolkit.telemetry.unified" = false;
                    "toolkit.telemetry.unifiedIsOptIn" = false;
                    "toolkit.telemetry.prompted" = 2;
                };
                userChrome = ''
                    .titlebar-buttonbox {
                        display: none;
                    }

                    .tab-secondary-label {
                        display: none;
                    }

                    #alltabs-button {
                        display: none;
                    }

                    /* .tab-close-button {
                        display: none;
                    } */

                    .tab-icon-overlay {
                        opacity: unset !important;
                        width: 20px !important;
                        height: 20px !important;
                    }

                    /* .tab-icon-overlay[soundplaying] {
                        display: none;
                    } */

                    /* .tab-icon-overlay[muted] {
                        display: none;
                    } */

                    .tab-context-line {
                        width: 100%;
                        height: 100% !important;
                        background-color: color-mix(in srgb, var(--identity-icon-color) 30%, transparent) !important;
                        margin: 0 !important;
                    }
                '';
            };
        };
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
                "InvalidCertificate" = true;
                "SafeBrowsing" = true;
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
                    "Locked" = true;
                };
                "Microphone" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = true;
                };
                "Location" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = true;
                };
                "Notifications" = {
                    "Allow" = [];
                    "Block" = [];
                    "BlockNewRequests" = true;
                    "Locked" = true;
                };
                "Autoplay" = {
                    "Allow" = ["https://www.twitch.tv" "https://clips.twitch.tv"];
                    "Block" = [];
                    "Default" = "block-audio-video";
                    "BlockNewRequests" = true;
                    "Locked" = true;
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
                "Locked" = true;
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
    };
}
