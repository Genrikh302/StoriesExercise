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
    @State private var viewModel: StoryListViewModel

    init(interactionStore: StoryInteractionStoring) {
        let repository = StoriesRepository()
        let viewModel = StoryListViewModel(
            repository: repository,
            interactionStore: interactionStore
        )
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            contentView()
        }
        .fullScreenCover(item: $viewModel.route) { route in
            switch route {
            case .storyPlayer(let stories, let initialIndex, let lastLoadedPage):
                let playerViewModel = StoryPlayerViewModel(
                    interactionStore: viewModel.interactionStore,
                    stories: stories,
                    initialIndex: initialIndex,
                    lastLoadedPage: lastLoadedPage
                )

                StoryPlayerView(viewModel: playerViewModel)
            }
        }
        .onChange(of: viewModel.route) { _, newValue in
            if newValue == nil {
                viewModel.refreshInteractions()
            }
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
        case .initialLoading:
            loadingView()
        case .error(let message):
            if viewModel.storyItems.isEmpty {
                errorView(message: message)
            } else {
                storiesScrollView()
            }
        }
    }

    private func storiesScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Constants.horizontalSpacing) {
                ForEach(viewModel.storyItems, id: \.id) { item in
                    StoryListItemView(story: item)
                        .frame(width: Constants.storyItemWidth)
                        .onAppear {
                            Task { // This will run only if we are close to the end so no need for .task
                                await viewModel.loadNextPageIfNeeded(currentItem: item)
                            }
                        }
                        .onTapGesture {
                            viewModel.itemTapped(item: item)
                        }
                }

                if viewModel.isPaginating {
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
