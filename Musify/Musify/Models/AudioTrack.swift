//
//  AudioTrack.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import Foundation

struct AudioTrack: Codable {
    
    let album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String:String]
    let id: String
    let name: String
}
