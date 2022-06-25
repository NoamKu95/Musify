//
//  NewReleasesResponse.swift
//  Musify
//
//  Created by Noam Kurtzer on 25/06/2022.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}
