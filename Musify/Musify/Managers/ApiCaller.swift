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
    
    public func fetchCurrentUserProfile(completionHandler: @escaping (Result<UserProfile, Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/me"), ofType: .GET) { baseRequest in
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
    
    public func fetchNewReleases(completionHandler: @escaping (Result<NewReleasesResponse,Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/browse/new-releases?limit=50"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func fetchFeaturedPlaylists(completionHandler: @escaping (Result<FeaturedPlaylistResponse,Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/browse/featured-playlists?limit=50"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func fetchRecommendedGenres(completionHandler: @escaping (Result<RecommendedGenresResponse,Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/recommendations/available-genre-seeds"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func fetchRecommendations(genres: Set<String>, completionHandler: @escaping (Result<RecommendationsResponse,Error>) -> ()) {
        
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/recommendations?seed_genres=\(seeds)"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func fetchAlbumDetails(for album: Album, completionHandler: @escaping (Result<AlbumDetailsResponse,Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/albums/\(album.id)"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func fetchPlaylistDetails(for playlist: Playlist, completionHandler: @escaping (Result<PlaylistDetailsResponse,Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/playlists/\(playlist.id)"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func fetchCategories(completionHandler: @escaping (Result<[Category],Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/browse/categories?limit=30"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    completionHandler(.success(result.categories.items))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func fetchCategoryPlaylists(categoryID: String, completionHandler: @escaping (Result<[Playlist],Error>) -> ()) {
        createRequest(with: URL(string: Constants.API.REQUESTS_BASE_API_URL + "/browse/categories/\(categoryID)/playlists?limit=30"), ofType: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    completionHandler(.success(result.playlists.items))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func search(with query: String, completionHandler: @escaping (Result<String,Error>) -> ()) {
        
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
