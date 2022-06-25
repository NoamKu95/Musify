//
//  RecommendationsResponse.swift
//  Musify
//
//  Created by Noam Kurtzer on 25/06/2022.
//

import Foundation

struct RecommendationsResponse: Codable {
    
    let tracks: [AudioTrack]
}
