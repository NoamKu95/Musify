//
//  RecommendationsResponse.swift
//  Musify
//
//  Created by Noam Kurtzer on 30/06/2022.
//

import Foundation

struct RecommendationsResponse: Codable {
    
    let tracks: [AudioTrack]
}
