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
        value: "Made with ❤️ in 🇨🇦",
        comment: "Text that's displayed at bottom of splash screen."
    )

    static let WHAT_IS_AUTOSPOTO = NSLocalizedString(
        "WHAT_IS_AUTOSPOTO",
        value: "What is it?",
        comment: "Title question on WhatIsAutoSpotoView."
    )

    static let WHAT_IS_AUTOSPOTO_ANSWER = NSLocalizedString(
        "MADE_WITH_LOVE",
        value: "AutoSpoto is a fully offline tool that converts your iMessage chats and groupchats into live updating playlists in your favourite streaming services.  You’ll be guided through the set up process in the coming pages.",
        comment: "Answer text to 'What is AutoSpoto?' on WhatIsAutoSpotoView."
    )

    static let CONTINUE = NSLocalizedString(
        "CONTINUE",
        value: "Continue",
        comment: "Generic 'Continue' string"
    )
}

