//
//  DiskAccessRequestCell.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-13.
//

import SwiftUI
import AVKit
import AppKit

struct DiskAccessRequestCell: View {
    @Binding var userAuthorizedDiskAcess: Bool
    
    @State private var player = AVLooperPlayer(url: Bundle.main.url(forResource: "Temp_Coaching", withExtension: "mov")!)
    
    @State var currentDate = Date.now
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var shakeAppIcon = 0
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_TITLE)
                    .font(.josefinSansSemibold(26))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.top, 8)
                
                Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_SUBTITLE)
                    .font(.josefinSansRegular(18))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 10)
                
                
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
                                    NSWorkspace.shared.open(AutoSpotoConstants.URL.fullDiskAccess)
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
                        .frame(maxWidth: 360)
                        
                        Text(AutoSpotoConstants.Strings.A_ONBOARDING_TEXT)
                            .font(.josefinSansBold(24))
                            .foregroundColor(.textPrimaryWhite)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .background(.regularMaterial)
                    .cornerRadius(8)
                    
                    ZStack(alignment: .topLeading) {
                        HStack(spacing: 30) {
                            VStack(alignment: .center, spacing: 8) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(.thickMaterial)
                                        .frame(width: 180, height: 180)
                                    
                                    Image("AutoSpotoAppLogo")
                                        .resizable()
                                        .frame(width: 170, height: 170)
                                        .modifier(Shake(animatableData: CGFloat(shakeAppIcon)))
                                        .draggable(Bundle.main.bundleURL)
                                }
                                
                                Text(AutoSpotoConstants.Strings.DRAG_AND_DROP_INSTRUCTION)
                                    .font(.josefinSansLight(14))
                                    .foregroundColor(.textPrimaryWhite)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.leading, 12)
                            
                            VideoPlayer(player: player)
                                .disabled(true)
                                .frame(width: 210 * 1.2, height: 189 * 1.2)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.ultraThickMaterial, lineWidth: 2)
                                )
                                .onAppear{
                                    self.player.play()
                                }
                                .padding(.trailing, 12)
                        }
                        .frame(maxHeight: .infinity)
                        
                        Text(AutoSpotoConstants.Strings.B_ONBOARDING_TEXT)
                            .font(.josefinSansBold(24))
                            .foregroundColor(.textPrimaryWhite)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .background(.regularMaterial)
                    .cornerRadius(8)
                }
                    .frame(height: 250)
                    .padding(.bottom, 15)
            }
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.regularMaterial, lineWidth: 2)
        )
        .cornerRadius(10)
        .onReceive(timer) { input in
            withAnimation {
                shakeAppIcon += 1
            }
        }
    }
}
