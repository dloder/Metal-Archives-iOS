//
//  RelatedLinkView.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 27/07/2021.
//

import Kingfisher
import SwiftUI

struct RelatedLinkView: View {
    @EnvironmentObject private var preferences: Preferences
    @State private var selectedUrlString: String?
    let relatedLink: RelatedLink

    var body: some View {
        HStack {
            KFImage(URL(string: relatedLink.favIconUrlString ?? ""))
                .resizable()
                .placeholder {
                    Image(systemName: "link")
                        .resizable()
                        .foregroundColor(.secondary)
                }
                .frame(width: 20, height: 20)

            Text(relatedLink.title)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .betterSafariView(urlString: $selectedUrlString,
                          tintColor: preferences.theme.primaryColor)
        .onTapGesture {
            selectedUrlString = relatedLink.urlString
        }
    }
}

struct RelatedLinkView_Previews: PreviewProvider {
    static var previews: some View {
        RelatedLinkView(relatedLink: .init(urlString: "https://www.facebook.com/DeathOfficial", title: "Facebook"))
    }
}
