//
//  ChooseMusicStreamingServiceView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct ChooseMusicStreamingServiceView: View {
    @State private var elementTransitionOpacity: CGFloat = 0
    
    @State private var showSpotifyLoginSheet: Bool = false
    @Binding var spotifyAccessToken: String?
    
    var body: some View {
        VStack {
            if spotifyAccessToken == nil {
                Text(AutoSpotoConstants.Strings.CHOOSE_MUSIC_STREAMING_SERVICE)
                    .font(.josefinSansSemibold(30))
                    .foregroundColor(.white)
                    .padding(.bottom, 60)
                
                VStack(spacing: 12) {
                    Button {
                        showSpotifyLoginSheet = true
                    } label: {
                        HStack {
                            Image("spotify-logo")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 8)
                            
                            Text(AutoSpotoConstants.Strings.CONNECT_WITH_SPOTIFY)
                                .foregroundColor(.white)
                                .font(.josefinSansRegular(18))
                            
                        }
                        .padding(12)
                        .background(in: RoundedRectangle(cornerRadius: 10))
                        .backgroundStyle(Color.spotifyGreen)
                        .frame(width: 400)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        print("pressed apple music")
                    } label: {
                        HStack {
                            Image("apple-logo")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 8)
                            
                            Text(AutoSpotoConstants.Strings.CONNECT_WITH_APPLE_MUSIC)
                                .foregroundColor(.white)
                                .font(.josefinSansRegular(18))
                            
                        }
                        .padding(12)
                        .background(in: RoundedRectangle(cornerRadius: 10))
                        .backgroundStyle(Color.appleMusicOragne)
                        .frame(width: 300)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                //connected to spotify
                Text(AutoSpotoConstants.Strings.SUCCESS)
                    .font(.josefinSansSemibold(40))
                    .foregroundColor(.white)
                    .padding(.bottom, 60)
                
                //TODO: Change in future when we allow user to connect with apple music
                Text(AutoSpotoConstants.Strings.CONNECTED_TO_SPOTIFY)
                    .font(.josefinSansSemibold(26))
                    .foregroundColor(.white)
                    .padding(.bottom, 60)
            }
        }
        .opacity(elementTransitionOpacity)
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
        .sheet(
            isPresented: $showSpotifyLoginSheet,
            content: {
                SpotifyLoginView(
                    spotifyAccessToken: $spotifyAccessToken,
                    isVisible: $showSpotifyLoginSheet
                )
            }
        )
        .onChange(
            of: spotifyAccessToken,
            perform: { _ in
                if let spotifyAccessToken = spotifyAccessToken {
                    let jsonObject = spotifyAccessToken.toJSON() as? [String:AnyObject]
                    
                    let access_string =  "{\"access_token\": \"\((jsonObject?["access_token"])!)\", "
                    let token_type = "\"token_type\": \"\((jsonObject?["token_type"])!)\", "
                    let expires_in = "\"expires_in\": \(3600), "
                    let scope = "\"scope\": \"\((jsonObject?["scope"])!)\", "
                    let expires_at = "\"expires_at\": \(Int (NSDate ().timeIntervalSince1970) + 3600), "
                    let refresh_token = "\"refresh_token\":\"\((jsonObject?["refresh_token"])!)\"}"
                    
                    let final_json = access_string + token_type + expires_in + scope + expires_at + refresh_token
                    
                    let url = URL (fileURLWithPath:"/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/.cache")
                    do {
                        try final_json.write(toFile: url.path, atomically: true, encoding: .utf8)
                        print(url)
                    } catch {
                        print(error)
                    }
                    showSpotifyLoginSheet = false
                }
            }
        )
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
