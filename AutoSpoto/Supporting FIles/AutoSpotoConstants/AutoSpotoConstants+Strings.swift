//
//  AutoSpotoConstants+Strings.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-16.
//

import Foundation

extension AutoSpotoConstants {
    struct Strings {
        private init() {}
    }
}

extension AutoSpotoConstants.Strings {
    static let AUTO_SPOTO_APP_NAME = NSLocalizedString(
        "AUTO_SPOTO_APP_NAME",
        value: "AutoSpoto",
        comment: "App name."
    )

    static let AUTO_SPOTO_SPLASH_MOTTO = NSLocalizedString(
        "AUTO_SPOTO_SPLASH_MOTTO",
        value: "Never lose a recommended song again.",
        comment: "AutoSpoto motto."
    )

    static let GET_STARTED = NSLocalizedString(
        "GET_STARTED",
        value: "Get started",
        comment: "Generic 'Get started' string."
    )

    static let MADE_WITH_LOVE = NSLocalizedString(
        "MADE_WITH_LOVE",
        value: "Made with ❤️ in 🇨🇦, 🇨🇴, 🇪🇨 & 🇯🇵.",
        comment: "Text that's displayed at bottom of splash screen."
    )

    static let WHAT_IS_AUTOSPOTO_ANSWER = NSLocalizedString(
        "MADE_WITH_LOVE",
        value: "AutoSpoto is a tool that connects your iMessage chats to live updating playlists in Spotify.",
        comment: "Answer text to 'What is AutoSpoto?' on PermissionsRequestView."
    )

    static let CONTINUE = NSLocalizedString(
        "CONTINUE",
        value: "Continue",
        comment: "Generic 'Continue' string"
    )

    static let FULL_DISK_ACCESS_PERMISSION_TITLE = NSLocalizedString(
        "FULL_DISK_ACCESS_PERMISSION_TITLE",
        value: "1. Grant AutoSpoto Full Disk Access",
        comment: "Generic 'Continue' string"
    )
    
    static let PLAYLIST_UPDATER_PERMISSION_TITLE = NSLocalizedString(
        "PLAYLIST_UPDATER_PERMISSION_TITLE",
        value: "2. Grant AutoSpoto Playlist Updater Full Disk Access",
        comment: "String explaining why user should allow disk access for updater"
    )

    static let PLAYLIST_UPDATER__PERMISSION_SUBTITLE = NSLocalizedString(
        "PLAYLIST_UPDATER__PERMISSION_SUBTITLE",
        value: "This is required so AutoSpoto can automatically update your Spotify playlists whenever you send or receive tracks.",
        comment: "Generic 'Continue' string"
    )
    
    static let FULL_DISK_ACCESS_PERMISSION_SUBTITLE = NSLocalizedString(
        "FULL_DISK_ACCESS_PERMISSION_SUBTITLE",
        value: "This is required so AutoSpoto can scan your messages for Spotify tracks you've shared and received.",
        comment: "Generic 'Continue' string"
    )

    static let OPEN_SETTINGS = NSLocalizedString(
        "OPEN_SETTINGS",
        value: "Open System Settings",
        comment: "Button title that allows user to open settings"
    )

    static let CONNECT_YOUR_SPOTIFY = NSLocalizedString(
        "CONNECT_YOUR_SPOTIFY",
        value: "Connect your Spotify account",
        comment: "Connect your Spotify account"
    )

    static let CONNECT_WITH_SPOTIFY = NSLocalizedString(
        "CONNECT_WITH_SPOTIFY",
        value: "Connect with Spotify",
        comment: "Title for button to allow the user to connect to Spotify"
    )

    static let CONNECT_WITH_APPLE_MUSIC = NSLocalizedString(
        "CONNECT_WITH_SPOTIFY",
        value: "Connect with Apple Music",
        comment: "Title for button to allow the user to connect to Apple Music"
    )

    static let CREATE_PLAYLIST = NSLocalizedString(
        "CREATE_PLAYLIST",
        value: "Connect chat to playlist",
        comment: "Title for button to allow the user to create a playlist from a chat"
    )
    
    static let MODIFY_PLAYLIST = NSLocalizedString(
        "MODIFY_PLAYLIST",
        value: "Modify VERY COOL playlist",
        comment: "Title for button to allow the user to modify an existing playlist from a chat"
    )
    
    static let MODIFY_PLAYLIST_WITH_NAME = NSLocalizedString(
        "MODIFY_PLAYLIST",
        value: "Modify '%@' playlist connection",
        comment: "Title for button to allow the user to modify an existing playlist from a chat"
    )

    static let TRACK_NAME_METADATA_PLACEHOLDER = NSLocalizedString(
        "TRACK_NAME",
        value: "Track Name",
        comment: "Placeholder for track name metadata"
    )

    static let TRACK_ARTIST_METADATA_PLACEHOLDER = NSLocalizedString(
        "TRACK_ARTIST",
        value: "Track Artist",
        comment: "Placeholder for tracka artist metadata"
    )

    static let TRACK_TIME_STAMP_METADATA_PLACEHOLDER = NSLocalizedString(
        "TRACK_TIME_STAMP_METADATA_PLACEHOLDER",
        value: "Track Time Stamp",
        comment: "Placeholder for tracka time stamp metadata"
    )

    static let ERROR_FETCHING_TRACK_METADATA = NSLocalizedString(
        "ERROR_FETCHING_TRACK_METADATA",
        value: "Invalid Spotify track link",
        comment: "Text displayed when there's an error fetching metadata for a track"
    )

    static let ERROR_INVALID_TRACK_URL = NSLocalizedString(
        "ERROR_INVALID_TRACK_URL",
        value: "Unfortunately, the ID for (%@) is invalid. The URL may be malformed.",
        comment: "Text displayed when there's a valid URL with an invalid ID"
    )

    static let NO_TRACKS_EMPTY_STATE = NSLocalizedString(
        "NO_TRACKS_EMPTY_STATE",
        value: "This chat does not appear to have any tracks yet",
        comment: "Text displayed when a chat has no tracks yet"
    )
    
    static let NO_CHATS_EMPTY_STATE = NSLocalizedString(
        "NO_CHATS_EMPTY_STATE",
        value: "It appears you don't have any chats",
        comment: "Text displayed when a user has no chats"
    )
    
    static let NUMBER_OF_TRACKS = NSLocalizedString(
        "NUMBER_OF_SONGS",
        value: "%d tracks",
        comment: "Number of tracks in the chat"
    )
    
    static let NUMBER_OF_UNSYNCED_TRACKS = NSLocalizedString(
        "NUMBER_OF_UNSYNCED_TRACKS",
        value: "(%d unsynced)",
        comment: "Number of unsynced tracks in the chat"
    )

    static let ENTER_PLAYLIST_DETAILS = NSLocalizedString(
        "ENTER_PLAYLIST_DETAILS",
        value: "Enter details for your playlist",
        comment: "Prompt for user to enter details about their plylist"
    )

    static let ENTER_PLAYLIST_NAME = NSLocalizedString(
        "ENTER_PLAYLIST_NAME",
        value: "Playlist name",
        comment: "Prompt for user to enter playlist name"
    )

    static let PLAYLIST_PLACEHOLDER_NAME = NSLocalizedString(
        "PLAYLIST_PLACEHOLDER_NAME",
        value: "My playlist",
        comment: "Placeholder name for playlist"
    )

    static let CREATE = NSLocalizedString(
        "CREATE",
        value: "Create",
        comment: "Generic 'Create' string"
    )

    static let INDIVIDUAL_PICKER_OPTION = NSLocalizedString(
        "INDIVIDUAL_PICKER_OPTION",
        value: "Individual",
        comment: "Title for segmented control option to filter singular chats"
    )

    static let GROUP_PICKER_OPTION = NSLocalizedString(
        "GROUP_PICKER_OPTION",
        value: "Group",
        comment: "Title for segmented control option to filter group chats"
    )

    static let CANCEL = NSLocalizedString(
        "CANCEL",
        value: "Cancel",
        comment: "Generic 'Cancel' string"
    )

    static let FINISH = NSLocalizedString(
        "FINISH",
        value: "Finish",
        comment: "Generic 'Finish' string"
    )

    static let SUCCESS = NSLocalizedString(
        "SUCCESS!",
        value: "Success! 🥳",
        comment: "Generic 'Success!' string"
    )

    static let CONNECTED_TO_SPOTIFY = NSLocalizedString(
        "CONNECTED_TO_SPOTIFY",
        value: "You are now connected to Spotify",
        comment: "Generic 'Success!' string"
    )

    static let COMING_SOON = NSLocalizedString(
        "COMING_SOON",
        value: "Coming soon",
        comment: "Used to flag upcoming features"
    )
    
    
    static let ERROR = NSLocalizedString(
        "ERROR",
        value: "Error",
        comment: "Generic 'Error' string"
    )
    
    static let UNEXPECTED_RESPONSE = NSLocalizedString(
        "UNEXPECTED_RESPONSE",
        value: "Unexpected HTTP response. Please try again.",
        comment: "Used to flag upcoming features"
    )
    
    static let ERROR_LOGGING_INTO_SPOTIFY = NSLocalizedString(
        "ERROR_LOGGING_INTO_SPOTIFY",
        value: "Error logging into Spotify. Please try again.",
        comment: "Used when there is an error logging into Spotify"
    )
    
    static let CHAT_HAS_NO_VALID_IDS = NSLocalizedString(
        "CHAT_HAS_NO_VALID_IDS",
        value: "It appears that all the Spotify IDs for this chat are invalid.",
        comment: "Error when user attempts to create a playlist entirely out of invalid IDs"
    )
    
    static let CHAT_CREATED_BY_AUTOSPOTO_DESCRIPTION = NSLocalizedString(
        "CHAT_CREATED_BY_AUTOSPOTO_DESCRIPTION",
        value: "This playlist was generated by AutoSpoto (https://autospoto.xyz).",
        comment: "The text that appears in the playlist created by AutoSpoto"
    )
    
    static let PRIVATE_PLAYLIST_SWITCH_TITLE = NSLocalizedString(
        "PRIVATE_PLAYLIST_SWITCH_TITLE",
        value: "This playlist should be private.",
        comment: "The text that appears next to the private switch"
    )
    
    static let ERROR_CREATING_PLAYLIST = NSLocalizedString(
        "ERROR_CREATING_PLAYLIST",
        value: "There was an error creating your playlist. Please try again.",
        comment: "The text that appears next to the private switch"
    )
    
    static let DONE = NSLocalizedString(
        "DONE",
        value: "Done",
        comment: "Generic 'Done' string"
    )
    
    static let SUCCESSFULLY_CREATED_PLAYLIST = NSLocalizedString(
        "SUCCESSFULLY_CREATED_PLAYLIST",
        value: "Your chat has been connected",
        comment: "The text that appears next to the private switch"
    )
    
    static let SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_INDIVIDUAL_CHAT = NSLocalizedString(
        "SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_INDIVIDUAL_CHAT",
        value: "From now on, any time a Spotify track is shared between you and %@, it will be added to '%@' playlist.",
        comment: "Subtitle success text after creating playlist."
    )
    
    static let SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_GROUP_CHAT = NSLocalizedString(
        "SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_INDIVIDUAL_CHAT",
        value: "From now on, any time a Spotify track is shared in %@, it will be added to '%@' playlist.",
        comment: "The text that appears next to the private switch"
    )
    
    static let DISCONNECT_CHAT_FROM_PLAYLIST = NSLocalizedString(
        "DISCONNECT_CHAT_FROM_PLAYLIST",
        value: "Disconnect chat",
        comment: "The text that appears next to the private switch (opting out of auto updates)"
    )
    
    static let SYNC_TRACKS = NSLocalizedString(
        "SYNC_TRACKS",
        value: "Manually sync tracks",
        comment: "A button that allows user to force a track sync"
    )
    
    static let FORCE_SYNC_BUTTON_OPTED_OUT_SUBTITLE = NSLocalizedString(
        "FORCE_SYNC_BUTTON_OPTED_OUT_SUBTITLE",
        value: "Since you've disabled automatic playlist updates for this chat, you will need to press this button whenever you'd like to update your playlist with the latest tracks.",
        comment: "Button subtitle that allows user to force a track sync (opted out of automatic updates)"
    )
    
    static let FORCE_SYNC_BUTTON_OPTED_IN_SUBTITLE = NSLocalizedString(
        "FORCE_SYNC_BUTTON_OPTED_IN_SUBTITLE",
        value: "Since you've enabled automatic playlist updates for this chat, this will automatically be done for you each hour.",
        comment: "Button subtitle that allows user to force a track sync (opted in to automatic updates)"
    )
    
    static let CONNECTED_TO = NSLocalizedString(
        "CONNECTED_TO",
        value: "Connected to:",
        comment: "Button subtitle that allows user to force a track sync (opted in to automatic updates)"
    )
    
    static let CHAT_NAME_PLACEHOLDER = NSLocalizedString(
        "CHAT_NAME_PLACEHOLDER",
        value: "My playlist",
        comment: "Generic placeholder chat name"
    )
    
    static let CHAT_URL_PLACEHOLDER = NSLocalizedString(
        "CHAT_URL_PLACEHOLDER",
        value: "https://open.spotify.com/playlist/xxxxxxxxxxxxxxxxxxxxxx",
        comment: "Generic placeholder spotify url"
    )
    
    static let PERMISSIONS_VIEW_TITLE = NSLocalizedString(
        "PERMISSIONS_VIEW_TITLE",
        value: "Complete these two tasks to set up AutoSpoto",
        comment: "Title for permissions view"
    )
    
    static let RESTART_INFO_SUBTITLE = NSLocalizedString(
        "RESTART_INFO_SUBTITLE",
        value: "You may need to restart AutoSpoto after you’ve given disk access.",
        comment: "Tell user that they may need to restart the app to see their disk access changes"
    )
    
    static let DRAG_AND_DROP_INSTRUCTION = NSLocalizedString(
        "DRAG_AND_DROP_INSTRUCTION",
        value: "Drag and drop this icon on to the Full Disk Access window.",
        comment: "Instructional text of what to do with the app icon."
    )
    
    static let FULL_DISK_ACCESS_BUTTON_INFO = NSLocalizedString(
        "FULL_DISK_ACCESS_BUTTON_INFO",
        value: "Click the button or go to System Settings > Privacy & Security > Full Disk Access.",
        comment: "Extra information about how they can access a certain page if clicking the button fails"
    )
    
    static let SPOTIFY_ACCESS_BUTTON_INFO = NSLocalizedString(
        "SPOTIFY_ACCESS_BUTTON_INFO",
        value: "Click the button and then enter your Spotify log in credentials.",
        comment: "Additional information about connecitng to Spotify"
    )
    
    static let A_ONBOARDING_TEXT = NSLocalizedString(
        "A_ONBOARDING_TEXT",
        value: "a.",
        comment: "Onboarding text denoting a. step"
    )
    
    static let B_ONBOARDING_TEXT = NSLocalizedString(
        "B_ONBOARDING_TEXT",
        value: "b.",
        comment: "Onboarding text denoting b. step"
    )
    
    static let JUST_A_COUPLE_THINGS_TEXT = NSLocalizedString(
        "JUST_A_COUPLE_THINGS_TEXT",
        value: "Just a few things to get set up",
        comment: "Title text for permissions screen"
    )
    
    static let SPOTIFY_PERMISSION_TITLE = NSLocalizedString(
        "SPOTIFY_PERMISSION_TITLE",
        value: "2. Connect your Spotify",
        comment: "Title text for spotify conncting"
    )
    
    static let SPOTIFY_PERMISSION_SUBTITLE = NSLocalizedString(
        "SPOTIFY_PERMISSION_SUBTITLE",
        value: "This is required so AutoSpoto can create Spotify playlists out of your message chats.",
        comment: "Title text for spotify subtitle"
    )
    
    static let ERROR_GETTING_AUTOSPOTO_DB = NSLocalizedString(
        "ERROR_GETTING_AUTOSPOTO_DB",
        value: "Error getting AutoSpoto DB",
        comment: "Error when getting autospoto db failed. Maybe cuz user revoked permissions."
    )
    
    static let ONBOARDING_SUCCESS = NSLocalizedString(
        "ONBOARDING_SUCCESS",
        value: "You're all set up. Now, lets start making playlists!",
        comment: "Displayed when user finishes onboarding."
    )
    
    static let PRIVACY_NEVER_LEAVES_YOUR_DEVICE = NSLocalizedString(
        "PRIVACY_NEVER_LEAVES_YOUR_DEVICE",
        value: "Don't worry, your sensitive data never leaves your device.",
        comment: "String that informs user their data is safe."
    )
    
    static let CHATS_WITH_TRACKS = NSLocalizedString(
        "CHATS_WITH_TRACKS",
        value: "Chats with tracks",
        comment: "Section title for section of chats with tracks"
    )
    
    static let CHATS_WITH_NO_TRACKS = NSLocalizedString(
        "CHATS_WITH_NO_TRACKS",
        value: "Chats with no tracks",
        comment: "Section title for section of chats with no tracks"
    )
    
    static let SPOTIFY_PLAYLIST_EXISTS_SECTION = NSLocalizedString(
        "SPOTIFY_PLAYLIST_EXISTS_SECTION",
        value: "Connected chats",
        comment: "Section title for section of chats connected to playlists"
    )
    
    static let CHAT_SECTION_EMPTY_STATE = NSLocalizedString(
        "CHAT_SECTION_EMPTY_STATE",
        value: "No chats yet",
        comment: "Empty state for chat with no tracks"
    )
    
    static let LAST_UPDATED = NSLocalizedString(
        "LAST_UPDATED",
        value: "Last updated: %@",
        comment: "Text displayed on PlaylistSummaryView"
    )
    
    static let LAST_UPDATED_FALLBACK = NSLocalizedString(
        "LAST_UPDATED_FALLBACK",
        value: "N/A",
        comment: "Fallback for last updated value. Should never occur."
    )
    
    static let UPGRADE_TO_PRO = NSLocalizedString(
        "UPGRADE_TO_PRO",
        value: "Upgrade to Pro",
        comment: "Label to upgrade to AutoSpoto Pro"
    )
    
    static let GROUP_CHAT_DISPLAY_NAME_FALLBACK = NSLocalizedString(
        "GROUP_CHAT_DISPLAY_NAME_FALLBACK",
        value: "Group chat #%@ (Unnamed)",
        comment: "Fallback for group chat name"
    )
    
    static let UKNOWN_NUMBER = NSLocalizedString(
        "UKNOWN_NUMBER",
        value: "Unknown number",
        comment: "Fallback for individual chat name"
    )
    
    static let SYNCED = NSLocalizedString(
        "SYNCED",
        value: "Synced",
        comment: "Generic 'Synced' text"
    )
    
    static let NOT_SYNCED = NSLocalizedString(
        "NOT_SYNCED",
        value: "Not synced",
        comment: "Generic 'Not synced' text"
    )
    
    static let INDIVIDUAL = NSLocalizedString(
        "INDIVIDUAL",
        value: "Individual",
        comment: "Generic 'Individual' text"
    )
    
    static let GROUP = NSLocalizedString(
        "GROUP",
        value: "Group",
        comment: "Generic 'Group' text"
    )
    
    static let CHAT_WAS_DELETED = NSLocalizedString(
        "CHAT_WAS_DELETED",
        value: "It appears this chat was deleted in Spotify.",
        comment: "Error message when adding to a playlist that was deleted."
    )
    
    static let UPGRADE_TO_AUTOSPOTO_PRO_TITLE = NSLocalizedString(
        "UPGRADE_TO_AUTOSPOTO_PRO",
        value: "Upgrade to AutoSpoto Pro",
        comment: "Title for upgrade to AutoSpoto Pro prompt."
    )
    
    static let UPGRADE_TO_AUTOSPOTO_PRO_SUBTITLE = NSLocalizedString(
        "UPGRADE_TO_AUTOSPOTO_PRO_SUBTITLE",
        value: "The free version of AutoSpoto allows you to connect to one chat. Connect unlimited chats with AutoSpoto Pro.",
        comment: "Subtitle for upgrade to AutoSpoto Pro prompt."
    )
    
    static let AUTOSPOTO_PRO_PRODUCT_TITLE = NSLocalizedString(
        "AUTOSPOTO_PRO_PRODUCT_TITLE",
        value: "AutoSpoto Pro",
        comment: "Product title for AutoSpoto Pro."
    )
    
    static let AUTOSPOTO_PRO_PRODUCT_SUBTITLE = NSLocalizedString(
        "AUTOSPOTO_PRO_PRODUCT_SUBTITLE",
        value: "Lifetime license",
        comment: "Product subtitle for AutoSpoto Pro."
    )
    
    static let AUTOSPOTO_PRO_PRODUCT_BUY_NOW = NSLocalizedString(
        "AUTOSPOTO_PRO_PRODUCT_BUY_NOW",
        value: "Buy now",
        comment: "Product buy now for AutoSpoto Pro."
    )
    
    static let AUTOSPOTO_PRO_PRODUCT_PRICE = NSLocalizedString(
        "AUTOSPOTO_PRO_PRODUCT_BUY_NOW",
        value: "$3.99 USD",
        comment: "Product price for AutoSpoto Pro."
    )
    
    static let NOT_NOW = NSLocalizedString(
        "NOT_NOW",
        value: "Not now",
        comment: "Button for if user doesn't want to upgrade to AutoSpoto Pro."
    )
    
    static let ACTIVATE_LICENSE = NSLocalizedString(
        "ACTIVATE_LICENSE",
        value: "Activate license",
        comment: "Button for if user wants to activate a license."
    )
    
    static let ACTIVATE_LICENSE_SUBTITLE = NSLocalizedString(
        "ACTIVATE_LICENSE_SUBTITLE",
        value: "Already purchased a license? Enter your license code and activate AutoSpoto Pro instantly.",
        comment: "Subtitle for activating license."
    )
}

