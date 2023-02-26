//
//  RelatedLinkView.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 27/07/2021.
//

import Kingfisher
import SwiftUI

struct RelatedLinkView: View {
    @Environment(\.selectedUrl) private var selectedUrl
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
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .onTapGesture {
            selectedUrl.wrappedValue = relatedLink.urlString
        }
    }
}

struct RelatedLinkView_Previews: PreviewProvider {
    static var previews: some View {
        RelatedLinkView(relatedLink: .init(urlString: "https://www.facebook.com/DeathOfficial", title: "Facebook"))
    }
}
