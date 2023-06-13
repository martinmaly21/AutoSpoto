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
    
    @State var player = AVLooperPlayer(url: Bundle.main.url(forResource: "Temp_Coaching", withExtension: "mov")!)
    
    @State var currentDate = Date.now
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State var shakeAppIcon = 0
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 5) {
                Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_TITLE)
                    .font(.josefinSansSemibold(26))
                    .foregroundColor(.textPrimaryWhite)
                
                Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_SUBTITLE)
                    .font(.josefinSansRegular(18))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 10)
                
                Divider()
                    .frame(height: 0.5)
                    .overlay(.ultraThinMaterial)
                    .padding(.horizontal, 16.5)
                
                HStack {
                    //                    ZStack(alignment: .topLeading) {
                    //                        VStack(alignment: .leading, spacing: 0) {
                    //                            Image(systemName: "opticaldiscdrive.fill")
                    //                                .resizable()
                    //                                .frame(width: 50, height: 40)
                    //                                .padding(.bottom, 15)
                    //
                    //                            OnboardingButton(
                    //                                title: AutoSpotoConstants.Strings.OPEN_SETTINGS,
                    //                                action: {
                    //                                    NSWorkspace.shared.open(AutoSpotoConstants.URL.fullDiskAccess)
                    //                                },
                    //                                width: 220,
                    //                                height: 30
                    //                            )
                    //                            .padding(.bottom, 8)
                    //
                    //                            Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_BUTTON_INFO)
                    //                                .font(.josefinSansLight(14))
                    //                                .foregroundColor(.textPrimaryWhite)
                    //                        }
                    //                        .padding()
                    //                    }
                    //                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    ZStack(alignment: .topLeading) {
                        HStack(spacing: 50) {
                            VideoPlayer(player: player)
                                .disabled(true)
                                .frame(width: 210 * 1.4, height: 189 * 1.4)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.ultraThickMaterial, lineWidth: 2)
                                )
                                .onAppear{
                                    self.player.play()
                                }
                            
                            VStack(alignment: .center, spacing: 20) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(.thickMaterial)
                                        .frame(width: 200, height: 200)
                                    
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
                        }
                        .padding()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .cornerRadius(10)
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.regularMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.regularMaterial, lineWidth: 2)
            )
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            .frame(height: 400)
            .onReceive(timer) { input in
                withAnimation {
                    shakeAppIcon += 1
                }
            }
        }
    }
}
