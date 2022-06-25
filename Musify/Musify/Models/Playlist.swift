//
//  Playlist.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import Foundation

struct Playlist: Codable {
    
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [ApiImage]
    let name: String
    let owner: User
}
