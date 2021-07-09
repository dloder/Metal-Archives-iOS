//
//  DiscographyView.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 08/07/2021.
//

import SwiftUI

struct DiscographyView: View {
    @EnvironmentObject private var preferences: Preferences
    @StateObject private var viewModel: DiscographyViewModel
    @State private var selectedMode: DiscographyMode = .complete
    @State private var releaseYearOrder: Order = .ascending

    init(discography: Discography) {
        _viewModel = StateObject(wrappedValue: .init(discography: discography))
    }

    var body: some View {
        Group {
            options
            ForEach(viewModel.releases(for: selectedMode,
                                       order: releaseYearOrder),
                    id: \.title) {
                Text($0.title)
            }
        }
    }

    private var options: some View {
        HStack {
            DiscographyModePicker(viewModel: viewModel,
                                  selectedMode: $selectedMode)
            Spacer()
            OrderView(order: $releaseYearOrder, title: "Release year")
        }
    }
}

struct DiscographyView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                DiscographyView(discography: .death)
                    .environmentObject(Preferences())
            }
        }
    }
}

private struct DiscographyModePicker: View {
    @EnvironmentObject private var preferences: Preferences
    @ObservedObject var viewModel: DiscographyViewModel
    @Binding var selectedMode: DiscographyMode

    var body: some View {
        Picker(selection: $selectedMode,
               label: selectedModeView) {
            ForEach(viewModel.modes, id: \.self) { mode in
                Text(viewModel.title(for: mode))
                    .tag(mode.rawValue)
            }
        }
        .pickerStyle(MenuPickerStyle())
    }

    private var selectedModeView: some View {
        Text(viewModel.title(for: selectedMode) + " ≡ ")
            .padding(6)
            .background(preferences.theme.primaryColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
