//
//  ProductsManager.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import UIKit

class ProductsManager {
    
    private var manager: NetworkManager
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(manager:NetworkManager = NetworkManager(baseUrl: "https://aster.getsandbox.com") ) {
        self.manager = manager
    }
    
    func getProducts(itemsCount:Int, from:Int, completion: @escaping (Result<[Product],APIError>) -> Void ){
        
        let queryItems = [URLQueryItem(name: "count", value: "\(itemsCount)"),
                          URLQueryItem(name: "from", value: "\(from)")]
        
        let request = APIRequest(method: .get, path: "products", queryItems: queryItems)
        manager.perform(request) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.managedObjectContext] = self.appDelegate.persistentContainer.viewContext
                if let response = try? response.decode(to: [Product].self, by: decoder) {
                    let products = response.body
                    completion(.success(products))
                } else {
                    completion(.failure(.decodingFailure))
                }
            case .failure:
                completion(.failure(.requestFailed))
            }
        }
    }
    
}
