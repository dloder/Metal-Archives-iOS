//
//  BandsByGenreView.swift
//  Metal Archives
//
//  Created by Nhon Nguyen on 22/10/2022.
//

import SwiftUI

struct BandsByGenreView: View {
    @StateObject private var viewModel: BandsByGenreViewModel

    init(apiService: APIServiceProtocol, genre: Genre) {
        _viewModel = .init(wrappedValue: .init(apiService: apiService, genre: genre))
    }

    var body: some View {
        ZStack {
            if let error = viewModel.error {
                VStack {
                    Text(error.userFacingMessage)
                    RetryButton {
                        await viewModel.getMoreBands(force: true)
                    }
                }
            } else if viewModel.isLoading && viewModel.bands.isEmpty {
                ProgressView()
            } else if viewModel.bands.isEmpty {
                Text("No bands found")
                    .font(.callout.italic())
            } else {
                bandList
            }
        }
        .task {
            await viewModel.getMoreBands(force: false)
        }
    }

    @ViewBuilder
    private var bandList: some View {
        List {
            ForEach(viewModel.bands, id: \.band.thumbnailInfo.urlString) { band in
                NavigationLink(destination: {
                    BandView(apiService: viewModel.apiService,
                             bandUrlString: band.band.thumbnailInfo.urlString)
                }, label: {
                    BandByAlphabetView(band: band)
                })
                .task {
                    if band == viewModel.bands.last {
                        await viewModel.getMoreBands(force: true)
                    }
                }

                if band == viewModel.bands.last, viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("\(viewModel.manager.total) bands by \"\(viewModel.genre.rawValue)\"")
        .navigationBarTitleDisplayMode(.large)
        .toolbar { toolbarContent }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu(content: {
                Button(action: {
                    viewModel.sortOption = .band(.ascending)
                }, label: {
                    view(for: .band(.ascending))
                })

                Button(action: {
                    viewModel.sortOption = .band(.descending)
                }, label: {
                    view(for: .band(.descending))
                })

                Button(action: {
                    viewModel.sortOption = .country(.ascending)
                }, label: {
                    view(for: .country(.ascending))
                })

                Button(action: {
                    viewModel.sortOption = .country(.descending)
                }, label: {
                    view(for: .country(.descending))
                })

                Button(action: {
                    viewModel.sortOption = .genre(.ascending)
                }, label: {
                    view(for: .genre(.ascending))
                })

                Button(action: {
                    viewModel.sortOption = .genre(.descending)
                }, label: {
                    view(for: .genre(.descending))
                })
            }, label: {
                Text(viewModel.sortOption.title)
            })
            .transaction { transaction in
                transaction.animation = nil
            }
            .opacity(viewModel.bands.isEmpty ? 0 : 1)
            .disabled(viewModel.bands.isEmpty)
        }
    }

    @ViewBuilder
    private func view(for option: BandsByGenrePageManager.SortOption) -> some View {
        if option == viewModel.sortOption {
            Label(option.title, systemImage: "checkmark")
        } else {
            Text(option.title)
        }
    }
}
