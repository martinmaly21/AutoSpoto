//
//  HomeContainerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct HomeContainerView: View {
    @StateObject var homeViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ChatsListView()
            ChatView()
                .frame(minWidth: 600)
        }
        .environmentObject(homeViewModel)
        .onAppear {
            Task {
                DiskAccessManager.checkSharedGroupContainer()
                await homeViewModel.fetchChats()
                PlaylistUpdaterManager.registerIfNeeded()
            }
        }
        .sheet(isPresented: $homeViewModel.allowlistRequiredAlertVisible) {
            VStack(spacing: 16) {
                Text(AutoSpotoConstants.Strings.ALLOWLIST_REQUIRED_TITLE)
                    .font(.josefinSansRegular(20))
                Text(AutoSpotoConstants.Strings.ALLOWLIST_REQUIRED_MESSAGE)
                    .font(.josefinSansRegular(15))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                HStack(spacing: 12) {
                    Button(AutoSpotoConstants.Strings.CONTACT_AUTOSPOTO) {
                        let subject = "Allowlist Request for AutoSpoto"
                        let body = "Hi AutoSpoto team,\n\nPlease add this Spotify email to your allowlist: <your-email>\n\nThanks!"
                        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        if let url = URL(string: "mailto:official.autospoto@gmail.com?subject=\(subjectEncoded)&body=\(bodyEncoded)") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    if homeViewModel.isRetryingAllowlist {
                        ProgressView()
                            .controlSize(.small)
                            .padding(.horizontal, 8)
                    } else {
                        Button(AutoSpotoConstants.Strings.TRY_AGAIN) {
                            Task { await homeViewModel.retryAfterAllowlist() }
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding(24)
            .frame(minWidth: 420)
            .interactiveDismissDisabled(true)
        }
    }
}
