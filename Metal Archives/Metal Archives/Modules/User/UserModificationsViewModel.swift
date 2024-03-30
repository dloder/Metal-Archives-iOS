//
//  UserModificationsViewModel.swift
//  Metal Archives
//
//  Created by Nhon Nguyen on 08/11/2022.
//

import Combine
import SwiftUI

final class UserModificationsViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var modifications: [UserModification] = []

    @Published var sortOption: UserModificationPageManager.SortOption {
        didSet { refresh() }
    }

    let apiService: APIServiceProtocol
    let manager: UserModificationPageManager
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIServiceProtocol, userId: String) {
        self.apiService = apiService
        let defaultSortOption: UserModificationPageManager.SortOption = .date(.descending)
        self.sortOption = defaultSortOption
        self.manager = .init(apiService: apiService, sortOptions: defaultSortOption, userId: userId)

        manager.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &cancellables)

        manager.$elements
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modifications in
                self?.modifications = modifications
            }
            .store(in: &cancellables)
    }

    @MainActor
    func getMoreModifications(force: Bool) async {
        if !force, !modifications.isEmpty { return }
        do {
            error = nil
            try await manager.getMoreElements()
        } catch {
            self.error = error
        }
    }

    func refresh() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                error = nil
                try await manager.updateOptionsAndRefresh(sortOption.options)
            } catch {
                self.error = error
            }
        }
    }
}
