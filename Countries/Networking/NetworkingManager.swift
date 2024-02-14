//
//  NetworkManager.swift
//  Countries
//
//  Created by Eric Barnes - iOS on 2/14/24.
//

import Foundation

struct NetworkingManager {
    
    static let shared = NetworkingManager()
    private init() {}
    
    func fetchAllCountries(completion: @escaping(Result<[Country], Error>) -> Void) {
        performRequest(route: .allCountries, method: .get, completion: completion)
    }
    
    // 1.
    /// Create URL Request
    /// - Parameters:
    ///   - route: targeted endpoint
    ///   - httpMethod: type of request being made
    ///   - parameters: add additional info to request
    /// - Returns: URLRequest?
    private func createRequest(route: Route, httpMethod: HTTPMethod, parameters: [String:Any]? = nil) -> URLRequest? {
        let urlString = Route.baseUrl + route.path
        
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue
        
        if let params = parameters {
            switch httpMethod {
            case .get: // append params to url
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
                urlComponents?.queryItems = params.map({ URLQueryItem(name: $0.key, value: "\($0.value)")})
                request.url = urlComponents?.url
            case .post: // add params into post body
                let bodyData = try? JSONSerialization.data(withJSONObject: params)
                request.httpBody = bodyData
            }
        }
        
        return request
    }
    
    // 2.
    private func performRequest<T: Decodable>(route: Route,
                                              method: HTTPMethod,
                                              parameters: [String:Any]? = nil,
                                              completion: @escaping(Result<T, Error>) -> Void) {
        guard let request = createRequest(route: route, httpMethod: method, parameters: parameters) else {
            completion(.failure(NetworkingError.invalidRequest))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, repsonse, error in
            var result: Result<Data, Error>?
            
            if let data = data {
                result = .success(data)
            } else if let error = error {
                result = .failure(error)
                print("Networking error:\n\(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.handleResponseFromRequest(result: result, completion: completion)
            }
        }.resume()
    }
    
    // 3.
    private func handleResponseFromRequest<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void) {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            
            guard let decodedData = try? decoder.decode(T.self, from: data) else {
                completion(.failure(NetworkingError.errorDecoding))
                return 
            }
            
            completion(.success(decodedData))
        case .failure(let error):
            completion(.failure(error))
        case nil: 
            fatalError("NO RESULT FOR API RESPONSE")
        }
    }
}
