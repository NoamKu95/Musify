//
//  Album.swift
//  Musify
//
//  Created by Noam Kurtzer on 25/06/2022.
//

import Foundation

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [ApiImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}
