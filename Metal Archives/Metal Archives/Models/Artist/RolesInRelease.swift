//
//  RoleInRelease.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 18/02/2019.
//  Copyright © 2019 Thanh-Nhon Nguyen. All rights reserved.
//

import Foundation
import Kanna

final class RolesInRelease {
    private(set) var year: Int!
    private(set) var release: ReleaseExtraLite!
    private(set) var roles: String!
    
    lazy var releaseTitleAttributedString: NSAttributedString = {
        let attributedString = NSMutableAttributedString(string: release.title)
        attributedString.addAttributes([.foregroundColor: Settings.currentTheme.secondaryTitleColor, .font: Settings.currentFontSize.secondaryTitleFont], range: NSRange(release.title.startIndex..., in: release.title))
        
        let additionalDetails = RegexHelpers.listMatches(for: #"\(.+\)"#, inString: release.title)
        
        additionalDetails.forEach({
            if let range = release.title.range(of: $0) {
                attributedString.addAttributes([.foregroundColor: Settings.currentTheme.bodyTextColor], range: NSRange(range, in: release.title))
            }
        })
        
        return attributedString
    }()
    
    init?(tr: XMLElement) {
        var i = 0
        
        for td in tr.css("td") {
            
            if (i == 0) {
                if let yearString = td.text, let yearInt = Int(yearString) {
                    self.year = yearInt
                } else {
                    return nil
                }
            }
                
            else if (i == 1) {
                if let releaseTitle = td.text?.removeHTMLTagsAndNoisySpaces() {
                    if let a = td.at_css("a"), let releaseURLString = a["href"] {
                        self.release = ReleaseExtraLite(urlString: releaseURLString, title: releaseTitle)
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
            else if (i == 2) {
                self.roles = td.text?.removeHTMLTagsAndNoisySpaces()
            }
            
            i = i + 1
        }
    }
}
