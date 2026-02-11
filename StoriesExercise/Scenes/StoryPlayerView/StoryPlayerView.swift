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
    @Environment(\.modelContext) private var modelContext

    init(viewModel: StoryPlayerViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoryContentView(story: viewModel.currentStory)
                .ignoresSafeArea()

            tapNavigationOverlay()

            likeButton()

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
                    let threshold: CGFloat = 80

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

    @ViewBuilder
    private func likeButton() -> some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button {
                    viewModel.toggleLike()
                } label: {
                    Image(systemName: viewModel.currentStory.isLiked ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundStyle(viewModel.currentStory.isLiked ? .red : .white)
                        .padding()
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}
