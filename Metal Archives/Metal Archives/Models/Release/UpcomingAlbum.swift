//
//  UpcomingAlbum.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 15/01/2019.
//  Copyright © 2019 Thanh-Nhon Nguyen. All rights reserved.
//

import Foundation

final class UpcomingAlbum: ThumbnailableObject {
    let bands: [BandLite]
    let release: ReleaseExtraLite
    let releaseType: ReleaseType
    let genre: String
    let date: String
    
    /*
     Sample array:
     "<a href="https://www.metal-archives.com/bands/Kalmankantaja/3540342889">Kalmankantaja</a> / <a href="https://www.metal-archives.com/bands/Drudensang/3540369476">Drudensang</a> / <a href="https://www.metal-archives.com/bands/Hiisi/3540401566">Hiisi</a>",
     "<a href="https://www.metal-archives.com/albums/Kalmankantaja_-_Drudensang_-_Hiisi/Essence_of_Black_Mysticism/775924">Essence of Black Mysticism</a>",
     "Split",
     "Depressive Black Metal (early), Atmospheric Black Metal (later) | Black Metal | Black Metal",
     "May 13th, 2019"
     */
    
    init?(from array: [String]) {
        guard array.count == 5 else { return nil }
        
        guard let release = ReleaseExtraLite(from: array[1]) else { return nil }
        
        guard let releaseType = ReleaseType(typeString: array[2]) else { return nil }
        
        // Workaround: In case of split release where there are many bands
        // replace " / " by a special character in order to split by this character (cause split string function only splits by character, not a string)
        var bands = [BandLite]()
        array[0].replacingOccurrences(of: " / ", with: "😡").split(separator: "😡").forEach({
            if let band = BandLite(from: String($0)) {
                bands.append(band)
            }
        })
        
        guard bands.count > 0 else { return nil }
        
        self.bands = bands
        self.release = release
        self.releaseType = releaseType
        self.genre = array[3]
        self.date = array[4]
        super.init(urlString: release.urlString, imageType: .release)
    }
}

//MARK: - Pagable
extension UpcomingAlbum: Pagable {
    static var rawRequestURLString = "https://www.metal-archives.com/release/ajax-upcoming/json/1?sEcho=1&iColumns=5&sColumns=&iDisplayStart=<DISPLAY_START>&iDisplayLength=100&mDataProp_0=0&mDataProp_1=1&mDataProp_2=2&mDataProp_3=3&mDataProp_4=4&iSortCol_0=4&sSortDir_0=asc&iSortingCols=1&bSortable_0=true&bSortable_1=true&bSortable_2=true&bSortable_3=true&bSortable_4=true"
    static var displayLenght = 100
    
    static func parseListFrom(data: Data) -> (objects: [UpcomingAlbum]?, totalRecords: Int?)? {
        guard let (totalRecords, array) = parseTotalRecordsAndArrayOfRawValues(data) else {
            return nil
        }
        var list: [UpcomingAlbum] = []
        
        array.forEach { (upcomingAlbumDetails) in
            if let upcomingAlbum = UpcomingAlbum(from: upcomingAlbumDetails) {
                list.append(upcomingAlbum)
            }
        }
        
        if list.count == 0 {
            return (nil, nil)
        }
        return (list, totalRecords)
    }
}

//MARK: - Actionable
extension UpcomingAlbum: Actionable {
    var actionableElements: [ActionableElement] {
        var elements: [ActionableElement] = []
        
        self.bands.forEach { (eachBand) in
            let bandElement = ActionableElement(name: eachBand.name, urlString: eachBand.urlString, type: .band)
            elements.append(bandElement)
        }
        
        let releaseElement = ActionableElement(name: self.release.name, urlString: self.release.urlString, type: .release)
        elements.append(releaseElement)
        
        return elements
    }
}
