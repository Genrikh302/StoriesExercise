//
//  SwiftUIView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI

@Observable
final class StoryListViewModel {
    var storyItems: [StoryBO] = []

    @ObservationIgnored private let pageSize = 20
    @ObservationIgnored private let maxWindowSize = 60
    @ObservationIgnored private var currentPage: Int = 0

    init() {
//        loadNextPageIfNeeded(currentItem: nil)
    }

    func addMore() {
//        items.append(contentsOf: [1,2,3])
        Task {
            let stories = try await StoriesRepository().loadStories(page: 20, pageSize: 30)
            storyItems = stories
            print("XX: story \(stories.first?.compactImageURL)")
        }
    }

    func itemTapped(item: StoryBO) {

    }

//    func loadNextPageIfNeeded(currentItem: Int?) {
//        guard shouldLoadMore(currentItem: currentItem) else { return }
//
//        let start = currentPage * pageSize
//        let end = start + pageSize
//        let newItems = Array(start..<end)
//
//        items.append(contentsOf: newItems)
//        currentPage += 1
//
//        trimWindowIfNeeded()
//    }
//
//    private func shouldLoadMore(currentItem: Int?) -> Bool {
//        guard let currentItem else { return true }
//        guard let index = items.firstIndex(of: currentItem) else { return false }
//
//        let thresholdIndex = items.index(items.endIndex, offsetBy: -5, limitedBy: items.startIndex) ?? items.startIndex
//        return index >= thresholdIndex
//    }
//
//    private func trimWindowIfNeeded() {
//        guard items.count > maxWindowSize else { return }
//        let excess = items.count - maxWindowSize
//        items.removeFirst(excess)
//    }
}

extension StoryListView {
    private enum Constants {
        static let verticalSpacing: CGFloat = 8
        static let horizontalSpacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 16

        static let storyItemWidth: CGFloat = 88
        static let storyItemSpacing: CGFloat = 8 // remove?
    }
}

struct StoryListView: View {
    @State private var viewModel = StoryListViewModel()

    init() {
//        viewModel = StoryListViewModel() // injection?
    }

    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            Button("add more") {
                viewModel.addMore()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.horizontalSpacing) {
                    ForEach(viewModel.storyItems, id: \.self) { item in
                        StoryListItemView(story: item)
                            .frame(width: Constants.storyItemWidth)
                            .onAppear {
//                                viewModel.loadNextPageIfNeeded(currentItem: item)
                            }
                            .onTapGesture {
                                viewModel.itemTapped(item: item)
                            }
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
    }
}

//#Preview {
//    SwiftUIView()
//}
