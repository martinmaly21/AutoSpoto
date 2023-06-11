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
        value: "AutoSpoto is a fully offline tool that converts your iMessage chats and groupchats into live updating playlists in your favourite music streaming services.  You’ll be guided through the set up process in the coming pages.",
        comment: "Answer text to 'What is AutoSpoto?' on DiskAccessIntroductionView."
    )

    static let CONTINUE = NSLocalizedString(
        "CONTINUE",
        value: "Continue",
        comment: "Generic 'Continue' string"
    )

    static let FULL_DISK_ACCESS_PERMISSION_TITLE = NSLocalizedString(
        "FULL_DISK_ACCESS_PERMISSION_TITLE",
        value: "AutoSpoto needs full disk access to continue.",
        comment: "Generic 'Continue' string"
    )

    static let FULL_DISK_ACCESS_PERMISSION_SUBTITLE = NSLocalizedString(
        "FULL_DISK_ACCESS_PERMISSION_TITLE",
        value: """
        Full disk access is required to access your iMessages.
        Once access has been granted, you will be able to progress to logging in with your preferred music streaming service.

        Note: a restart may be required.
        """,
        comment: "Generic 'Continue' string"
    )

    static let OPEN_SETTINGS = NSLocalizedString(
        "OPEN_SETTINGS",
        value: "Open settings",
        
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
        value: "Error fetching track information for: %@",
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

    static let NUMBER_OF_TRACKS = NSLocalizedString(
        "NUMBER_OF_SONGS",
        value: "%d tracks",
        comment: "Number of tracks in the chat"
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
        value: "This playlist was generated by AutoSpoto (https://autospoto.com). Last updated: %@.",
        comment: "The text that appears in the playlist created by AutoSpoto"
    )
    
    static let PRIVATE_PLAYLIST_SWITCH_TITLE = NSLocalizedString(
        "PRIVATE_PLAYLIST_SWITCH_TITLE",
        value: "This playlist should be private.",
        comment: "The text that appears next to the private switch"
    )
    
    static let AUTOMATIC_PLAYLIST_UPDATES_SINGLE_CHAT = NSLocalizedString(
        "AUTOMATIC_PLAYLIST_UPDATES_SINGLE_CHAT",
        value: "Automatically update your playlist with any new tracks shared between you and %@.",
        comment: "The text that appears next to the private switch"
    )
    
    static let AUTOMATIC_PLAYLIST_UPDATES_GROUP_CHAT = NSLocalizedString(
        "AUTOMATIC_PLAYLIST_UPDATES_GROUP_CHAT",
        value: "Automatically update your playlist with any new tracks shared between in %@.",
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
    
    static let SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_INDIVIDUAL_CHAT_SCHEDULER_OPT_OUT = NSLocalizedString(
        "SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_INDIVIDUAL_CHAT_SCHEDULER_OPT_OUT",
        value: "Since you opted out of automatic playlist updates, you will need to open AutoSpoto and manually sync '%@' playlist to add any new Spotify tracks shared between you and %@.",
        comment: "Subtitle success text after creating playlist (opting out of auto updates)."
    )
    
    static let SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_GROUP_CHAT_SCHEDULER_OPT_OUT = NSLocalizedString(
        "SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_GROUP_CHAT_SCHEDULER_OPT_OUT",
        value: "Since you opted out of automatic playlist updates, you will need to open AutoSpoto and manually sync '%@' playlist to add any new Spotify tracks shared in %@.",
        comment: "The text that appears next to the private switch (opting out of auto updates)"
    )
    
    static let DISCONNECT_CHAT_FROM_PLAYLIST = NSLocalizedString(
        "DISCONNECT_CHAT_FROM_PLAYLIST",
        value: "Disconnect chat",
        comment: "The text that appears next to the private switch (opting out of auto updates)"
    )
    
    static let SYNC_TRACKS = NSLocalizedString(
        "SYNC_TRACKS",
        value: "Sync tracks",
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
    
}

