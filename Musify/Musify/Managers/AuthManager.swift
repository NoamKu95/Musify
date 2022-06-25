//
//  AuthManager.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import Foundation

class AuthManager {
    
    static let shared = AuthManager()
    private var isRefreshingToken = false
    
    private init() {}
    
    
    public var url : URL? {
        return URL(string: Constants.API.SIGN_IN_URL)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.ACCESS_TOKEN)
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.REFRESH_TOKEN)
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.EXPIRATION_DATE) as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let fiveMinutes: TimeInterval = 300
        let currentDate = Date()
        return currentDate.addingTimeInterval(TimeInterval(fiveMinutes)) >= expirationDate
    }
    
    
    // MARK: - Functions
    
    func exchangeCodeToAccessToken(code: String, completionHandler: @escaping (Bool) -> ()) {
        
        guard let url = URL(string: Constants.API.TOEKN_BASE_API_URL) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add the required Body properties and encode them
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.API.REDIRECT_URI),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        
        // Add the required Header properties
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let stringForAuthorization = "\(Constants.API.CLIENT_ID):\(Constants.API.CLIENT_SECRET)"
        let data = stringForAuthorization.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to encode client id and secret for header request")
            completionHandler(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completionHandler(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheTokens(from: result)
                completionHandler(true)
            } catch {
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
        task.resume()
        
    }
    
    func cacheTokens(from result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: Constants.UserDefaultsKeys.ACCESS_TOKEN)
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: Constants.UserDefaultsKeys.EXPIRATION_DATE)
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: Constants.UserDefaultsKeys.REFRESH_TOKEN)
        }
    }
    
    func refreshAccessTokenIfNeeded(completionHandler: ((Bool) -> Void)?) {
        guard !isRefreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completionHandler?(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }

        guard let url = URL(string: Constants.API.TOEKN_BASE_API_URL) else {
            return
        }
        
        isRefreshingToken = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add the required Body properties and encode them
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: self.refreshToken),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        
        // Add the required Header properties
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let stringForAuthorization = "\(Constants.API.CLIENT_ID):\(Constants.API.CLIENT_SECRET)"
        let data = stringForAuthorization.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to encode client id and secret for header request")
            completionHandler?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.isRefreshingToken = false
            
            guard let data = data, error == nil else {
                completionHandler?(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                // Execute all the colsures that are waiting for the token
                self?.onRefreshBlocks.forEach({$0(result.access_token)})
                self?.onRefreshBlocks.removeAll()
                
                self?.cacheTokens(from: result)
                completionHandler?(true)
            } catch {
                print(error.localizedDescription)
                completionHandler?(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [(String) -> ()]()
    
    func withValidToken(completionHandler: @escaping (String) -> ()) {
        
        // If  we are currently in the middle of token refresh
        guard !isRefreshingToken else {
            onRefreshBlocks.append(completionHandler) // execute the completion handler when new token was received
            return
        }
        
        // If we are not in the middle of refreshing the token
        if shouldRefreshToken {
            refreshAccessTokenIfNeeded { [weak self] success in
                if success {
                    if let token = self?.accessToken {
                        completionHandler(token)
                    }
                }
            }
        } else if let token = accessToken {
            completionHandler(token)
        }
    }
    
    
}
