//
//  Constants.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import Foundation

struct Constants {
    
    struct Segues {
        static let SPLASH_TO_WELCOME = "splashToWelcome"
        static let WELCOME_TO_AUTH = "welcomeToAuth"
        static let HOME_TO_SETTINGS = "homeToSettings"
        static let SETTINGS_TO_PROFILE = "settingsToProfile"
    }
    
    struct Cells {
        static let NEW_RELEASES = "newReleases_Cell"
        static let FEATURED_PLAYLIST = "featuredPlaylist_Cell"
        static let RECOMMENDATION = "recommendation_Cell"
    }

    
    struct API {
        static let CLIENT_ID = "728403febfe040f7800ea1feed743bc3"
        static let CLIENT_SECRET = "dcdecf8c7f7e44e68b39626616397f9a"
        
        static let ACCOUNT_BASE_API_URL = "https://accounts.spotify.com"
        static let TOEKN_BASE_API_URL = "https://accounts.spotify.com/api/token"
        static let REQUESTS_BASE_API_URL = "https://api.spotify.com/v1"
        
        static let REDIRECT_URI = "https://iosacademy.io"
        static let SCOPES = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        static let SIGN_IN_URL = "\(Constants.API.ACCOUNT_BASE_API_URL)/authorize?response_type=code&client_id=\(Constants.API.CLIENT_ID)&scope=\(Constants.API.SCOPES)&redirect_uri=\(Constants.API.REDIRECT_URI)&show_dialog=TRUE"
    }
    
    struct UserDefaultsKeys {
        static let ACCESS_TOKEN = "access_token"
        static let REFRESH_TOKEN = "refresh_token"
        static let EXPIRATION_DATE = "expiration_date"
    }
}
