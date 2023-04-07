//
//  MovieStore.swift
//  MovieAppTest
//
//  Created by QuyNM on 3/27/23.
//

import Foundation

class MovieStore: MovieService {
   
    static let shared = MovieStore()
    private init() {}
    
    private let apikey = "e6dc8c20ea0d4c49874b8fa5173a1309"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func fetchMovie(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "appemd_to_response" : "videos,credits"], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language":"en-US",
            "region":"US",
            "include_adult":"false",
            "query": query
        ], completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D,MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apikey)]
        if let params = params {
            queryItems.append(contentsOf: params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            })
            
            urlComponents.queryItems = queryItems
            
            guard let finalURL = urlComponents.url else {
                completion(.failure(.invalidEndpoint))
                return
            }
            
            urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if error != nil {
                    self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                    return
                }
                
                guard let httpRessponse = response as? HTTPURLResponse, 200..<300 ~= httpRessponse.statusCode else {
                    self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                    return
                }
                
                guard let data = data else {
                    self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                    return
                }

                do {
                    let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                    self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
                } catch {
                    self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
                }
            }.resume()
        }
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
