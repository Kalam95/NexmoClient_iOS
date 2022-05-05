//
//  NetworkLayer.swift
//  UniversalApp_swift
//
//  Created by Mehboob Alam on 28.04.22.
//

import Foundation

enum HTTPErrors: Error {
    case noInternet
    case unKnownFailure
    case badRequest
    case badURL
    case invalidData
}

class NetworkLayer {
    var task: URLSessionDataTask?


    func getRequest<T: Decodable>(url: URL,
                                  headers: [String: String] = AppManager.shared.basicHeaders,
                                  completion: @escaping (Result<T, HTTPErrors>) -> Void ) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.badRequest))
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.invalidData))
            }
        })
        task?.resume()
    }

    func postRequest<T: Decodable>(url: URL, parameters: [String: Any],
                                   headers: [String: String] = AppManager.shared.basicHeaders,
                                   completion: @escaping (Result<T, HTTPErrors>) -> Void ) {
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            completion(.failure(.badRequest))
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.httpBody = body
        
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.badRequest))
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.invalidData))
            }
        })
        task?.resume()
    }
}

