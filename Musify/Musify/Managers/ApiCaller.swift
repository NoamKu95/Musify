//
//  ApiCaller.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import Foundation

enum HTTPMethod : String {
    case GET
    case POST
}

enum APIError : Error {
    case failedToGetData
}

class ApiCaller {
    
    static let shared = ApiCaller()
    
    private init() {}
    
    public func getCurrentUserProfile(completionHandler: @escaping (Result<UserProfile, Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.PROFILE_BASE_API_URL + "/me"), ofType: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data) // JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(with url: URL?, ofType type: HTTPMethod, completiongHandler: @escaping (URLRequest) -> ()) {
        guard let apiURL = url else {
            return
        }

        AuthManager.shared.withValidToken { token in
            var request = URLRequest(url: apiURL)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completiongHandler(request)
        }
    }
}
