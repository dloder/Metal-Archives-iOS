//
//  Utilities.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 12/05/2019.
//  Copyright © 2019 Thanh-Nhon Nguyen. All rights reserved.
//

import UIKit
import FirebaseAnalytics

func openReviewOnAppStore() {
    let appStoreURLString = "https://itunes.apple.com/app/id1074038930?action=write-review"
    UIApplication.shared.open(URL(string: appStoreURLString)!, options: [:]) { (finished) in
        Analytics.logEvent(AnalyticsEvent.MadeAReview, parameters: nil)
    }
}

func calculateCollectionViewHeight(cellHeight: CGFloat,itemPerRow: Int) -> CGFloat {
    guard itemPerRow > 0 else {
        fatalError("Item per row for collection view must be greater than 0")
    }
    
    //let totalItemSpacing = Settings.collectionViewItemSpacing * CGFloat(itemPerRow - 1)
    //Workaround
    let totalItemSpacing = Settings.collectionViewItemSpacing * CGFloat(itemPerRow - 1) + 4 //4 is magic number
    return ceil(cellHeight * CGFloat(itemPerRow) + Settings.collectionViewContentInset.top + Settings.collectionViewContentInset.bottom + totalItemSpacing)
}

// Convenience method to extract a hyperlink and value of an html <a> tag
func getUrlAndValueFrom(tagA: String) -> (urlString: String, value: String)? {
    // Replace ' with " cause the site sometimes use between the 2 quotes
    let string = tagA.replacingOccurrences(of: "'", with: "\"")
    
    guard let urlSubstring = string.subString(after: #"href=""#, before: #"">"#, options: .caseInsensitive),
        let valueSubstring = string.subString(after: #"">"#, before: "</a>", options: .caseInsensitive) else {
        return nil
    }
    
    return (String(urlSubstring), String(valueSubstring))
}
