#!/usr/bin/env bash

set -euo pipefail

FIREFOX_PATH="/Users/apose/Library/Application Support/Firefox/Profiles/o2shkdx2.default-release"

>&2 echo "Manual step: Add  _github.com.pose.lastUpdated to about:config and press return."
read

>&2 echo "Close Firefox and press return."
read

LAST_UPDATED_ENTRY="_github.com.pose.lastUpdated"
LAST_UPDATED_VALUE="$(date)"

cat << EOF > "$FIREFOX_PATH/user.js"
// Mozilla User Preferences

// Set last update
// XXX Manual step: Create this preference on about:config
user_pref("$LAST_UPDATED_ENTRY", "$LAST_UPDATED_VALUE");

// Set vertical tabs
user_pref("sidebar.verticalTabs", true);

// Remove newtab stuff
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.enabled", false);

// Set homepage to an empty tab
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");

// Do not show thumbnails of tabs
user_pref("browser.tabs.hoverPreview.showThumbnails", false);

// Disable sending data reporting
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.usage.uploadEnabled", false);

EOF
>&2 echo "user.js file replaced successfully."

>&2 echo "Open and close Firefox then press return."
read


>&2 echo "Verify that configuration was saved on pref.js"
>&2 echo "Value written: $LAST_UPDATED_VALUE"
>&2 echo "Value read: "
cat "$FIREFOX_PATH/prefs.js" | egrep --color "$LAST_UPDATED_ENTRY"

