//
//  ChatsListView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    @State private var pickerOptions = [
        AutoSpotoConstants.Strings.INDIVIDUAL_PICKER_OPTION,
        AutoSpotoConstants.Strings.GROUP_PICKER_OPTION
    ]

    var body: some View {
        let topInset: CGFloat = 80

        ZStack(alignment: .top) {
            ScrollView {
                Spacer()
                    .frame(height: topInset)
                VStack(spacing: 0) {
                    ForEach(homeViewModel.chats.indices, id: \.self) { index in
                        let chat = homeViewModel.chats[index]
                        ChatRow(chat: chat, isSelected: index == homeViewModel.selectedChatIndex)
                            .onTapGesture {
                                homeViewModel.selectedChatIndex = index
                            }
                    }
                }
            }
            .introspectScrollView { scrollView in
                scrollView.scrollerInsets = NSEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }

            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                        .font(.josefinSansBold(26))
                        .foregroundColor(.white)


                    Spacer()

                    Button(
                        action: {
                            //TODO: fetch chats
                        },
                        label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    )
                    .frame(width: 30, height: 30)

                }
                .padding(.horizontal, 18)
                .padding(.top, 20)
                .padding(.bottom, 10)

                Picker("", selection: $pickerOptions) {
                    ForEach(pickerOptions, id: \.self) {
                        Text($0)
                            .foregroundColor(.blue)
                            .font(.josefinSansRegular(16))
                    }
                }
                .pickerStyle(.segmented)
                .padding(.trailing, 6)
                .padding(.bottom, 30)
                .introspectSegmentedControl { segmentedControl in
                    segmentedControl.selectedSegmentBezelColor = .blue
                }
            }
            .frame(height: topInset)
            .background(.ultraThinMaterial)
        }
    }
}
