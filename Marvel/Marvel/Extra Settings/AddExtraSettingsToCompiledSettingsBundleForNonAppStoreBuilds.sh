#!/bin/sh

set -e
set -x

if [ ${CONFIGURATION} == "Debug" ] || [ ${CONFIGURATION} == "Demo" ]; then

    COMPILED_SETINGS_BUNDLE_PLIST_PATH="$CODESIGNING_FOLDER_PATH/Settings.bundle/Root.plist"
    EXTRA_SETTINGS_PLIST_PATH="$PROJECT_DIR/Marvel/Extra\ Settings/ExtraSettings.plist"
    SETINGS_BUNDLE_PLIST_PATH="$PROJECT_DIR/Marvel/Settings.bundle/Root.plist"

    # The app is not always built after a clean.
    # Most of the time the settings.bundle in the compiled app is not recopied after a build
    # This step manually copies it over to prevent the settings being appended multiple times
    cp $SETINGS_BUNDLE_PLIST_PATH $COMPILED_SETINGS_BUNDLE_PLIST_PATH

    # Append the settings in the ExtraSettings.plist to the exisiting settings.bundle
    /usr/libexec/PlistBuddy -c "merge $EXTRA_SETTINGS_PLIST_PATH :PreferenceSpecifiers" "$COMPILED_SETINGS_BUNDLE_PLIST_PATH"
fi

