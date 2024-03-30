//
//  ReviewViewModel.swift
//  Metal Archives
//
//  Created by Nhon Nguyen on 16/10/2022.
//

import Kingfisher
import SwiftUI

@MainActor
final class ReviewViewModel: ObservableObject {
    @Published private(set) var reviewFetchable: FetchableObject<Review> = .fetching
    @Published private(set) var coverFetchable: FetchableObject<UIImage?> = .fetching

    let apiService: APIServiceProtocol
    let urlString: String

    var review: Review? {
        switch reviewFetchable {
        case .fetched(let review):
            return review
        default:
            return nil
        }
    }

    var isFetchingCover: Bool {
        switch coverFetchable {
        case .fetching:
            return true
        default:
            return false
        }
    }

    var cover: UIImage? {
        switch coverFetchable {
        case .fetched(let cover):
            return cover
        default:
            return nil
        }
    }

    init(apiService: APIServiceProtocol, urlString: String) {
        self.apiService = apiService
        self.urlString = urlString
    }

    func fetchRelease() async {
        if case .fetched = reviewFetchable { return }
        do {
            reviewFetchable = .fetching
            let review = try await apiService.request(forType: Review.self, urlString: urlString)
            reviewFetchable = .fetched(review)
        } catch {
            reviewFetchable = .error(error)
        }
    }

    func fetchCoverImage() async {
        guard let urlString = review?.coverPhotoUrlString,
              let url = URL(string: urlString) else { return }
        do {
            coverFetchable = .fetching
            let cover = try await KingfisherManager.shared.retrieveImage(with: url)
            coverFetchable = .fetched(cover)
        } catch {
            coverFetchable = .error(error)
        }
    }
}
