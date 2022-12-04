//
//  AdvancedSearchResultView.swift
//  Metal Archives
//
//  Created by Nhon Nguyen on 04/12/2022.
//

import SwiftUI

struct AdvancedSearchResultView<T: HashableEquatablePageElement>: View {
    @StateObject var viewModel: AdvancedSearchResultViewModel<T>
    @State private var selectedBandUrl: String?
    @State private var selectedReleaseUrl: String?

    var body: some View {
        let isShowingBandDetail = makeIsShowingBandDetailBinding()
        let isShowingReleaseDetail = makeIsShowingReleaseDetailBinding()

        ZStack {
            NavigationLink(
                isActive: isShowingBandDetail,
                destination: {
                    if let selectedBandUrl {
                        BandView(apiService: viewModel.apiService, bandUrlString: selectedBandUrl)
                    } else {
                        EmptyView()
                    }},
                label: { EmptyView() })

            NavigationLink(
                isActive: isShowingReleaseDetail,
                destination: {
                    if let selectedReleaseUrl {
                        ReleaseView(apiService: viewModel.apiService,
                                    urlString: selectedReleaseUrl,
                                    parentRelease: nil)
                    } else {
                        EmptyView()
                    }},
                label: { EmptyView() })

            if let error = viewModel.error {
                VStack {
                    Text(error.userFacingMessage)
                    RetryButton(onRetry: viewModel.refresh)
                }
            } else if viewModel.isLoading && viewModel.results.isEmpty {
                HornCircularLoader()
            } else if viewModel.results.isEmpty {
                NoResultsView(query: nil)
            } else {
                resultList
            }
        }
        .task {
            await viewModel.getMoreResults(force: false)
        }
    }

    private func makeIsShowingBandDetailBinding() -> Binding<Bool> {
        .init(get: {
            selectedBandUrl != nil
        }, set: { newValue in
            if !newValue {
                selectedBandUrl = nil
            }
        })
    }

    private func makeIsShowingReleaseDetailBinding() -> Binding<Bool> {
        .init(get: {
            selectedReleaseUrl != nil
        }, set: { newValue in
            if !newValue {
                selectedReleaseUrl = nil
            }
        })
    }

    @ViewBuilder
    private var resultList: some View {
        List {
            ForEach(viewModel.results, id: \.hashValue) { result in
                view(for: result)
                .task {
                    if result == viewModel.results.last {
                        await viewModel.getMoreResults(force: true)
                    }
                }

                if result == viewModel.results.last, viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("\(viewModel.manager.total) result(s)")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func view(for result: some HashableEquatablePageElement) -> some View {
        if let result = result as? BandAdvancedSearchResult {
            BandAdvancedSearchResultView(result: result)
                .onTapGesture {
                    selectedBandUrl = result.band.thumbnailInfo.urlString
                }
        } else {
            EmptyView()
        }
    }
}

private struct BandAdvancedSearchResultView: View {
    @EnvironmentObject private var preferences: Preferences
    let result: BandAdvancedSearchResult

    var body: some View {
        HStack {
            ThumbnailView(thumbnailInfo: result.band.thumbnailInfo,
                          photoDescription: result.band.name)
            .font(.largeTitle)
            .foregroundColor(preferences.theme.secondaryColor)
            .frame(width: 64, height: 64)

            VStack(alignment: .leading) {
                if let note = result.note {
                    Text(result.band.name)
                        .fontWeight(.bold)
                        .foregroundColor(preferences.theme.primaryColor) +
                    Text(" (\(note))")
                } else {
                    Text(result.band.name)
                        .fontWeight(.bold)
                        .foregroundColor(preferences.theme.primaryColor)
                }

                switch result.countryOrLocation {
                case .country(let country):
                    Text(country.nameAndFlag)
                        .foregroundColor(preferences.theme.secondaryColor)
                case .location(let location):
                    Text(location)
                        .font(.callout)
                }

                if let label = result.label {
                    Text(label)
                        .font(.callout)
                }

                Text(result.year)
                    .font(.callout)

                Text(result.genre)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
    }
}
