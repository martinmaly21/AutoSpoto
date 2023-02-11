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
        value: "Made with ❤️ in 🇨🇦.",
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

    static let CHOOSE_MUSIC_STREAMING_SERVICE = NSLocalizedString(
        "CHOOSE_MUSIC_STREAMING_SERVICE",
        value: "Choose your preferred music streaming service",
        comment: "Title for screen to allow the user to choose their streaming service"
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

    static let ERROR_FETCHING_TRACK_METADATA = NSLocalizedString(
        "ERROR_FETCHING_TRACK_METADATA",
        value: "Error fetching track information for: %@",
        comment: "Text displayed when there's an error fetching metadata for a track"
    )

    static let NO_TRACKS_EMPTY_STATE = NSLocalizedString(
        "NO_TRACKS_EMPTY_STATE",
        value: "This chat does not appear to have any tracks yet",
        comment: "Text displayed when a chat has no tracks yet"
    )

    static let NUMBER_OF_SONGS = NSLocalizedString(
        "NUMBER_OF_SONGS",
        value: "%d songs",
        comment: "Number of songs in the chat"
    )
}

