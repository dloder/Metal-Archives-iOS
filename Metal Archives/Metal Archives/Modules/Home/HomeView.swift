//
//  HomeView.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 19/06/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var preferences: Preferences
    @State private var detail: Detail?
    let apiService: APIServiceProtocol

    var body: some View {
        ScrollView {
            VStack {
                DetailView(detail: $detail, apiService: apiService)

                Text("What's news on Metal Archives today")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom)

                ForEach(preferences.homeSectionOrder) { section in
                    switch section {
                    case .latestAdditions:
                        LatestAdditionsSection(apiService: apiService, detail: $detail)
                    case .latestUpdates:
                        LatestUpdatesSection()
                    case .latestReviews:
                        LatestReviewsSection(apiService: apiService, detail: $detail)
                    case .upcomingAlbums:
                        UpcomingAlbumsSection(apiService: apiService, detail: $detail)
                    }
                }
            }
        }
        .navigationTitle(Text(navigationTitle))
        .navigationBarTitleDisplayMode(.large)
    }

    private var navigationTitle: String {
        let formatter = DateFormatter(dateFormat: "EEEE, d MMM yyyy")
        return formatter.string(for: Date()) ?? "Metal Archives"
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(apiService: APIService())
            .environment(\.colorScheme, .dark)
            .environmentObject(Preferences())
    }
}
