//
//  APIRequest.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct HTTPHeader {
    let field: String
    let value: String
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?

    init(method: HTTPMethod, path: String, queryItems:[URLQueryItem]? = nil, headers:[HTTPHeader]? = nil) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
    }

    init<Body: Encodable>(method: HTTPMethod, path: String, body: Body) throws {
        self.method = method
        self.path = path
        self.body = try JSONEncoder().encode(body)
    }
}
