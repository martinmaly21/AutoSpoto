//
//  AutoSpotoDiskAccessRequestCell.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-13.
//

import SwiftUI
import AVKit
import AppKit

struct AutoSpotoDiskAccessRequestCell: View {
    @Binding var userAuthorizedDiskAccess: Bool
    
    @State private var player = AVLooperPlayer(url: Bundle.main.url(forResource: "Disk_Access_Coaching", withExtension: "mov")!)
    
    @State var currentDate = Date.now
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var shakeAppIcon = 0
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_TITLE)
                            .font(.josefinSansSemibold(26))
                            .foregroundColor(.textPrimaryWhite)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, userAuthorizedDiskAccess ? 10 : 0)
                            .strikethrough(userAuthorizedDiskAccess, pattern: .solid)
                            .opacity(userAuthorizedDiskAccess ? 0.3 : 1)
                        
                        Image(systemName: userAuthorizedDiskAccess ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .tint(.green)
                    }
                    
                    if !userAuthorizedDiskAccess {
                        Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_SUBTITLE)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.textPrimaryWhite)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 20) {
                            ZStack(alignment: .topLeading) {
                                VStack(alignment: .center, spacing: 0) {
                                    Image(systemName: "opticaldiscdrive.fill")
                                        .resizable()
                                        .frame(width: 150 * 0.86, height: 120 * 0.86)
                                        .padding(.bottom, 30)
                                    
                                    OnboardingButton(
                                        title: AutoSpotoConstants.Strings.OPEN_SETTINGS,
                                        action: {
                                            let openPanel = NSOpenPanel()
                                            openPanel.canChooseFiles = false
                                            openPanel.canChooseDirectories = true
                                            openPanel.allowsMultipleSelection = false
                                            openPanel.directoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Messages")
                                            
                                            openPanel.begin { (result) in
                                                if result == .OK, let url = openPanel.urls.first {
                                                    guard url.absoluteString.contains("/Library/Messages") else {
                                                        //TODO: handle error of user hitting wrong folder better
                                                        return
                                                    }
                                                    
                                                    do {
                                                        UserDefaultsManager.libraryBookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                                                        
                                                        guard let autoSpotoURL = DiskAccessManager.autoSpotoURL else {
                                                            fatalError("Could not get autoSpotoURL")
                                                        }
                                                        DiskAccessManager.startAccessingSecurityScopedResource()
                                                        try FileManager.default.createDirectory (at: autoSpotoURL, withIntermediateDirectories: true, attributes: nil)
                                                        DiskAccessManager.stopAccessingSecurityScopedResource()
                                                    } catch let error {
                                                        fatalError("Could not save libraryBookmarkData to userdefaults. Error: \(error)")
                                                    }
                                                }
                                            }
                                        },
                                        width: 220,
                                        height: 30
                                    )
                                    .padding(.bottom, 14)
                                    
                                    Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_BUTTON_INFO)
                                        .font(.josefinSansLight(14))
                                        .padding(.horizontal, 16.5)
                                        .foregroundColor(.textPrimaryWhite)
                                }
                                .frame(maxHeight: .infinity)
                                .frame(maxWidth: 400)
                                
                                Text(AutoSpotoConstants.Strings.A_ONBOARDING_TEXT)
                                    .font(.josefinSansBold(24))
                                    .foregroundColor(.textPrimaryWhite)
                                    .padding(.leading, 14)
                                    .padding(.top, 10)
                            }
                            .background(.regularMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.thickMaterial, lineWidth: 2)
                            )
                            .cornerRadius(8)
                            
                            ZStack(alignment: .topLeading) {
                                HStack(spacing: 30) {
                                    VStack(alignment: .center, spacing: 8) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 40)
                                                .fill(.clear)
                                                .frame(width: 180, height: 180)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 40)
                                                        .stroke(.white.opacity(0.4), lineWidth: 0.5)
                                                )
                                            
                                            Image("OnboardingAppIcon")
                                                .resizable()
                                                .frame(width: 180, height: 180)
                                                .modifier(Shake(animatableData: CGFloat(shakeAppIcon)))
                                                .draggable(Bundle.main.bundleURL)
                                        }
                                        
                                        Text(AutoSpotoConstants.Strings.DRAG_AND_DROP_INSTRUCTION)
                                            .font(.josefinSansLight(14))
                                            .foregroundColor(.textPrimaryWhite)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    
                                    VideoPlayer(player: player)
                                        .disabled(true)
                                        .frame(width: 210 * 1.12, height: 189 * 1.2)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.ultraThickMaterial, lineWidth: 2)
                                        )
                                        .onAppear{
                                            self.player.play()
                                        }
                                }
                                
                                Text(AutoSpotoConstants.Strings.B_ONBOARDING_TEXT)
                                    .font(.josefinSansBold(24))
                                    .foregroundColor(.textPrimaryWhite)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.regularMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.thickMaterial, lineWidth: 2)
                            )
                            .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .padding(.bottom, 15)
                        .onReceive(timer) { input in
                            withAnimation {
                                shakeAppIcon += 1
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .cornerRadius(10)
                
                if !userAuthorizedDiskAccess {
                    Text(AutoSpotoConstants.Strings.PRIVACY_NEVER_LEAVES_YOUR_DEVICE)
                        .font(.josefinSansLight(14))
                        .foregroundColor(Color.gray)
                        .padding(.top, -8)
                        .padding(.leading, 24)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.regularMaterial, lineWidth: 2)
        )
        .cornerRadius(10)
    }
}
