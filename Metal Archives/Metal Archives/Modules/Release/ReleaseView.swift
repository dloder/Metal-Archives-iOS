//
//  ReleaseView.swift
//  Metal Archives
//
//  Created by Nhon Nguyen on 30/07/2022.
//

import SwiftUI

struct ReleaseView: View {
    @StateObject private var viewModel: ReleaseViewModel
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol,
         releaseUrlString: String) {
        self.apiService = apiService
        let vm = ReleaseViewModel(apiService: apiService,
                                  releaseUrlString: releaseUrlString)
        _viewModel = .init(wrappedValue: vm)
    }

    var body: some View {
        ZStack {
            switch viewModel.releaseFetchable {
            case .fetching, .waiting:
                HornCircularLoader()
            case .fetched(let release):
                ReleaseContentView(apiService: apiService,
                                   release: release)
                .environmentObject(viewModel)
            case .error(let error):
                VStack {
                    Text(error.userFacingMessage)
                    RetryButton(onRetry: {
                        Task {
                            await viewModel.fetchRelease()
                        }
                    })
                }
            }
        }
        .task {
            await viewModel.fetchRelease()
        }
    }
}

private struct ReleaseContentView: View {
    @EnvironmentObject private var preferences: Preferences
    @EnvironmentObject private var viewModel: ReleaseViewModel
    @Environment(\.selectedPhoto) private var selectedPhoto
    @ObservedObject private var tabsDatasource = ReleaseTabsDatasource()
    @State private var titleViewAlpha = 0.0
    @State private var coverViewHeight: CGFloat = 300
    @State private var coverScaleFactor: CGFloat = 1.0
    @State private var coverOpacity: Double = 1.0
    private let minCoverScaleFactor: CGFloat = 0.5
    private let maxCoverScaleFactor: CGFloat = 1.2
    let apiService: APIServiceProtocol
    let release: Release

    var body: some View {
        ZStack(alignment: .top) {
            ReleaseCoverView(scaleFactor: $coverScaleFactor,
                             opacity: $coverOpacity)
                .environmentObject(viewModel)
                .frame(height: coverViewHeight)
                .frame(maxWidth: .infinity)

            OffsetAwareScrollView(
                axes: .vertical,
                showsIndicator: true,
                onOffsetChanged: { point in
                    /// Calculate `titleViewAlpha`
                    let screenBounds = UIScreen.main.bounds
                    if point.y < 0,
                       abs(point.y) > (min(screenBounds.width, screenBounds.height) * 2 / 3) {
                        titleViewAlpha = abs(point.y) / min(screenBounds.width, screenBounds.height)
                    } else {
                        titleViewAlpha = 0.0
                    }

                    /// Calculate `coverScaleFactor` & `coverOpacity`
                    if point.y < 0 {
                        var factor = min(1.0, 70 / abs(point.y))
                        factor = factor < minCoverScaleFactor ? minCoverScaleFactor : factor
                        coverScaleFactor = factor
                        coverOpacity = (factor - minCoverScaleFactor) / minCoverScaleFactor
                    } else {
                        var factor = max(1.0, point.y / 70)
                        factor = factor > maxCoverScaleFactor ? maxCoverScaleFactor : factor
                        coverScaleFactor = factor
                    }
                },
                content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Color.clear
                            .frame(height: coverViewHeight)

                        Text(release.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(
                                    gradient: .init(colors: [Color(.systemBackground),
                                                             Color(.systemBackground.withAlphaComponent(0.9)),
                                                             Color(.systemBackground.withAlphaComponent(0.7)),
                                                             Color(.systemBackground.withAlphaComponent(0.5)),
                                                             Color(.systemBackground.withAlphaComponent(0.3)),
                                                             Color(.systemBackground.withAlphaComponent(0.1)),
                                                             Color.clear]),
                                    startPoint: .bottom,
                                    endPoint: .top)
                            )

                        HorizontalTabs(datasource: tabsDatasource)
                            .padding(.bottom)
                            .background(Color(.systemBackground))

                        VStack {
                            ForEach(0...100, id: \.self) { _ in
                                Text("")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                    }
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                })
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar { toolbarContent }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Group {
                switch viewModel.coverFetchable {
                case .fetched(let image):
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding(.vertical, 4)
                    }
                default:
                    EmptyView()
                }
            }
            .opacity(titleViewAlpha)
        }

        ToolbarItem(placement: .principal) {
            Text(release.title)
                .font(.title2)
                .fontWeight(.bold)
                .textSelection(.enabled)
                .minimumScaleFactor(0.5)
                .opacity(titleViewAlpha)
        }
    }
}

/*
struct ReleaseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReleaseView(apiService: APIService(),
                        releaseUrlString: "https://www.metal-archives.com/albums/Death/Human/606")
        }
        .environment(\.colorScheme, .dark)
        .environmentObject(Preferences())
    }
}
*/
