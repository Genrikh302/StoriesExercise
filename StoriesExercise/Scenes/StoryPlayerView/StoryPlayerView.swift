//
//  StoryPlayerView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI

struct StoryPlayerView: View {
    @State private var viewModel: StoryPlayerViewModel
    @Environment(\.dismiss) private var dismiss

    init(stories: [StoryBO], initialIndex: Int, lastLoadedPage: Int) {
        _viewModel = State(
            initialValue: StoryPlayerViewModel(
                stories: stories,
                initialIndex: initialIndex,
                lastLoadedPage: lastLoadedPage
            )
        )
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoryContentView(story: viewModel.currentStory)
                .ignoresSafeArea()

            tapNavigationOverlay()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .padding()
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding()
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 80 // move to constants

                    if value.translation.width < -threshold {
                        withAnimation(.easeInOut) {
                            viewModel.goNext()
                        }
                    } else if value.translation.width > threshold {
                        withAnimation(.easeInOut) {
                            viewModel.goPrevious()
                        }
                    }
                }
        )
        .background(Color.black)
    }

    @ViewBuilder
    private func tapNavigationOverlay() -> some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        viewModel.goPrevious()
                    }
                }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        viewModel.goNext()
                    }
                }
        }
        .ignoresSafeArea()
    }
}
