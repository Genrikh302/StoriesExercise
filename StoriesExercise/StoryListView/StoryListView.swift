//
//  SwiftUIView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI

extension StoryListView {
    private enum Constants {
        static let verticalSpacing: CGFloat = 8
        static let horizontalSpacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 16

        static let storyItemWidth: CGFloat = 88
    }
}

struct StoryListView: View {
    @State private var viewModel = StoryListViewModel()

    init() {
//        viewModel = StoryListViewModel() // injection?
    }

    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            contentView()
        }
        .task {
            if viewModel.storyItems.isEmpty {
                await viewModel.loadNextPageIfNeeded(currentItem: nil)
            }
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.state {
        case .idle:
            storiesScrollView()
        case .loading:
            if viewModel.storyItems.isEmpty {
                loadingView()
            } else {
                storiesScrollView(showPaginationLoader: true)
            }
        case .error(let message):
            if viewModel.storyItems.isEmpty {
                errorView(message: message)
            } else {
                storiesScrollView()
            }
        }
    }

    private func storiesScrollView(showPaginationLoader: Bool = false) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Constants.horizontalSpacing) {
                ForEach(viewModel.storyItems, id: \.self) { item in
                    StoryListItemView(story: item)
                        .frame(width: Constants.storyItemWidth)
                        .onAppear {
                            Task { // This will run only if 
                                await viewModel.loadNextPageIfNeeded(currentItem: item)
                            }
                        }
                        .onTapGesture {
                            viewModel.itemTapped(item: item)
                        }
                }

                if showPaginationLoader {
                    ProgressView()
                        .frame(width: Constants.storyItemWidth)
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
    }

    private func loadingView() -> some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 8) {
            Text("Something went wrong")
                .font(.headline)
            Text(message)
                .font(.caption)
                .multilineTextAlignment(.center)

            Button("Retry") {
                Task {
                    await viewModel.loadNextPageIfNeeded(currentItem: nil)
                }
            }
        }
    }
}

//#Preview {
//    SwiftUIView()
//}
