//
//  MyAccountView.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 19/06/2021.
//

import SwiftUI

struct MyAccountView: View {
    var body: some View {
        Text("My account")
    }
}

#Preview {
    MyAccountView()
        .environment(\.colorScheme, .dark)
        .environmentObject(Preferences())
}
