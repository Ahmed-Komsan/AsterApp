//
//  APIClient.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import Foundation
import UIKit

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type, by decoder:JSONDecoder = JSONDecoder()) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        
        let decodedJSON = try decoder.decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode, body: decodedJSON)
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
}

enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}

struct NetworkManager {

    private let session: URLSession
    private let baseURL: URL
    
    init(session:URLSession = URLSession.shared , baseUrl:String) {
        self.session = session
        self.baseURL = URL(string: baseUrl)!
    }

    func perform(_ request: APIRequest, _ completion: @escaping (APIResult<Data?>) -> Void ) {

        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems

        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL));
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body

        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }

        let task = session.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode, error == nil else {
                completion(.failure(.requestFailed));
                return
            }
            completion(.success(APIResponse<Data?>(statusCode: response.statusCode, body: data)))
        }
        task.resume()
    }
}
