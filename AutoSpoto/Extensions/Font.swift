//
//  Font.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-16.
//

import SwiftUI

extension Font {
    static func josefinSansBold(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans Bold", size: size, relativeTo: relativeTo)
    }

    static func josefinSansBoldItalic(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans Bold Italic", size: size, relativeTo: relativeTo)
    }

    static func josefinSansLight(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans Light", size: size, relativeTo: relativeTo)
    }

    static func josefinSansLightItalic(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans Light Italic", size: size, relativeTo: relativeTo)
    }

    static func josefinSansRegular(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans Regular", size: size, relativeTo: relativeTo)
    }

    static func josefinSansSemibold(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans SemiBold", size: size, relativeTo: relativeTo)
    }

    static func josefinSansThin(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans Thin", size: size, relativeTo: relativeTo)
    }

    static func josefinSansThinItalic(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        return Font.custom("Josefin Sans Thin Italic", size: size, relativeTo: relativeTo)
    }
}
