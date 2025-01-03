//
//  NetworkService.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

protocol INetworkService {
    func fetch<T:Codable> (baseUrl: String, route: String, method: HTTPMethod, type: T.Type, parameters: Parameters?, completionHandler: @escaping (Result<T, Error>) -> Void)
}

class RemoteNetworkService: INetworkService {
    
    func fetch<T: Codable>(baseUrl: String, route: String, method: HTTPMethod, type: T.Type, parameters: Parameters? = nil, completionHandler: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\("https://api.github.com/")\(route)"
        guard let url = urlString.asURL else {
            Logger.printIfDebug(data: "unable to get url", logType: .error)
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = parameters.map {
                    URLQueryItem(name: $0, value: "\($1)")
                }
                request.url = urlComponent?.url
            case .post, .delete, .patch, .head, .put:
                let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = bodyData
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                Logger.printIfDebug(data: "\(error), \(error.localizedDescription)", logType: .error)
            }
            
            if let response = response {
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                if statusCode > 400 {
                    completionHandler(.failure(NetworkError.error(statusCode: statusCode, data: nil)))
                }
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(response))
                } catch let error {
                    Logger.printIfDebug(data: "The error is: \(error)", logType: .error)
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(NetworkError.invalidData))
            }
        }
        
        task.resume()
        
    }
    
}
