//
//  AutoSpotoDisconnectView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-08-23.
//

import SwiftUI

struct AutoSpotoDisconnectView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(AutoSpotoConstants.Strings.DISCONNECT_AUTOSPOTO)
                        .font(.josefinSansSemibold(32))
                        .foregroundColor(.textPrimaryWhite)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 16)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Text(AutoSpotoConstants.Strings.DISCONNECT_AUTOSPOTO_FROM_SPOTIFY)
                            .font(.josefinSansSemibold(26))
                            .foregroundColor(.textPrimaryWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        textWithHighlightedLink(string: AutoSpotoConstants.Strings.DISCONNECT_AUTOSPOTO_FROM_SPOTIFY_INSTRUCTIONS)
                            .font(.josefinSansRegular(18))
                            .lineSpacing(10)
                            .onTapGesture {
                                NSWorkspace.shared.open(AutoSpotoConstants.URL.autoSpotoDisconnectSpotify)
                            }
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .background(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.regularMaterial, lineWidth: 2)
                )
                .cornerRadius(10)
                .padding(.horizontal, 16)
                
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Text(AutoSpotoConstants.Strings.DISCONNECT_AUTOSPOTO_FROM_DEVICE)
                            .font(.josefinSansSemibold(26))
                            .foregroundColor(.textPrimaryWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Text(AutoSpotoConstants.Strings.DISCONNECT_AUTOSPOTO_FROM_DEVICE_INSTRUCTIONS)
                            .font(.josefinSansRegular(18))
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    ClearAssociatedDataButton {
                        print("Test")
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .background(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.regularMaterial, lineWidth: 2)
                )
                .cornerRadius(10)
                .padding(.horizontal, 16)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    DoneButton {
                        isVisible = false
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .frame(width: 1000, height: 600)
    }
    
    func textWithHighlightedLink(string: String) -> Text {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        else {
            return Text(string)
        }

        let stringRange = NSRange(location: 0, length: string.count)

        let matches = detector.matches(
            in: string,
            options: [],
            range: stringRange
        )

        let attributedString = NSMutableAttributedString(string: string)
        for match in matches {
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single, range: match.range)
        }

        var text = Text("")
        attributedString.enumerateAttributes(in: stringRange, options: []) { attrs, range, _ in
            var t = Text(attributedString.attributedSubstring(from: range).string)
            if attrs[.underlineStyle] != nil {
                t = t
                    .foregroundColor(.gray)
                    .underline()
            } else {
                t = t
                    .foregroundColor(Color(NSColor.labelColor))
            }

            text = text + t
        }

        return text
    }
}


