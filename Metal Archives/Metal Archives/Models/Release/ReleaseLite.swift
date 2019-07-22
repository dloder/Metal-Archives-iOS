//
//  ReleaseLite.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 30/01/2019.
//  Copyright © 2019 Thanh-Nhon Nguyen. All rights reserved.
//

import UIKit

final class ReleaseLite: ThumbnailableObject {
    let title: String
    let type: ReleaseType
    let year: Int
    let numberOfReviews: Int?
    let rating: Int?
    let reviewsURLString: String?
    
    lazy var attributedDescription: NSAttributedString = {
        var yearAndTitleString = "\(year) • \(type.description)"
        
        if let numberOfReviews = numberOfReviews {
            yearAndTitleString = "\(year) • \(type.description) • "
        }
        
        let yearAndTitleAttributedString = NSMutableAttributedString(string: yearAndTitleString)

        yearAndTitleAttributedString.addAttributes([.foregroundColor: Settings.currentTheme.bodyTextColor, .font: Settings.currentFontSize.bodyTextFont], range: NSRange(yearAndTitleString.startIndex..., in: yearAndTitleString))
        
        guard let numberOfReviews = numberOfReviews , let rating = rating else {
            return yearAndTitleAttributedString
        }
        
        let ratingString = "\(numberOfReviews) (\(rating)%)"
        
        let ratingAttributedString = NSMutableAttributedString(string: ratingString)
        ratingAttributedString.addAttributes([.foregroundColor: UIColor.colorByRating(rating), .font: Settings.currentFontSize.bodyTextFont], range: NSRange(ratingString.startIndex..., in: ratingString))
        
        yearAndTitleAttributedString.append(ratingAttributedString)
        
        return yearAndTitleAttributedString
    }()
    
    init?(urlString: String, type: ReleaseType, title: String, year: Int, numberOfReviews: Int?, rating: Int?, reviewsURLString: String?) {
        self.title = title
        self.year = year
        self.type = type
        self.numberOfReviews = numberOfReviews
        self.rating = rating
        self.reviewsURLString = reviewsURLString
        super.init(urlString: urlString, imageType: .release)
    }
}

extension ReleaseLite {
    override var generalDescription: String {
        return "\(id) - \(title) - \(year) - \(type.description)"
    }
}
