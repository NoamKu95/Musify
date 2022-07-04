//
//  CategoriesResponse.swift
//  Musify
//
//  Created by Noam Kurtzer on 04/07/2022.
//

import Foundation

struct CategoriesResponse : Codable {
    
    let categories: Categories
    
}

struct Categories : Codable {
    
    let items: [Category]
}

struct Category : Codable {
    
    let id: String
    let name: String
    let icons: [ApiImage]
}
