//
//  RequestTop100Bands.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 27/02/2019.
//  Copyright © 2019 Thanh-Nhon Nguyen. All rights reserved.
//

import Foundation

extension RequestHelper.StatisticDetail {
    typealias FetchTop100BandsOnSuccess = (_ top100Bands: Top100Bands) -> Void
    typealias FetchTop100BandsOnError = (Error) -> Void
    
    static func fetchTop100Bands(onSuccess: @escaping FetchTop100BandsOnSuccess, onError: @escaping FetchTop100BandsOnError) {
        let urlString = "https://www.metal-archives.com/stats/bands"
        let requestURL = URL(string: urlString)!
        
        RequestHelper.shared.alamofireManager.request(requestURL).responseData { (response) in
            switch response.result {
            case .success:
                if let data = response.data, let top100Bands = Top100Bands.init(fromData: data) {
                    onSuccess(top100Bands)
                } else {
                    let error = MAParsingError.badStructure(objectType: "Top 100 Bands")
                    onError(error)
                }
                
            case .failure(let error): onError(error)
            }
        }
    }
}
