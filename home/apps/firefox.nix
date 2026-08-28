{ ... }:

{
  # Firefox itself and its portable profile behavior are managed together.
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        # Sidebar and vertical tabs. Firefox's accompanying migration and
        # engagement preferences are runtime state, not configuration.
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks,opentabs";

        # Scheduled profile backups. The last filename and timestamp remain
        # runtime state in the profile.
        "browser.backup.location" = "/home/joel/Documents/Restore Firefox";
        "browser.backup.scheduled.enabled" = true;

        # Clear temporary and identifying site data on shutdown, but retain
        # browsing/download history and site permission settings.
        "privacy.history.custom" = true;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown_v2.cache" = true;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
        "privacy.clearOnShutdown_v2.downloads" = false;
        "privacy.clearOnShutdown_v2.siteSettings" = false;
      };
    };

    policies = {
      BrowserDataBackup = {
        AllowBackup = true;
        AllowRestore = true;
      };

      # Persistent cookie exceptions from the current profile. Short-lived
      # storage-access grants and extension permissions remain runtime state.
      Cookies = {
        Allow = [
          "https://account.proton.me"
          "https://apple.com"
          "https://appleid.apple.com"
          "https://chatgpt.com"
          "https://github.com"
          "https://mail.proton.me"
          "https://proton.me"
          "https://youtube.com"
        ];
        Locked = false;
      };
    };
  };
}
