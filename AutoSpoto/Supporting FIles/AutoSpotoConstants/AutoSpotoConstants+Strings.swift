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
        value: "Create playlist",
        comment: "Title for button to allow the user to create a playlist from a group chat"
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
        value: "Enter your playlist name",
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
}

