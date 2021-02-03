//
//  Product.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

class Product: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case productName
        case productDescription
        case image
        case price
    }
    
    @NSManaged public var id: Int
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?
    @NSManaged public var productName: String?
    @NSManaged public var image: ProductImage?
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.productDescription = try container.decode(String.self, forKey: .productDescription)
        self.image = try container.decode(ProductImage.self, forKey: .image)
        self.price = try container.decode(Double.self, forKey: .price)
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(productName, forKey: .productName)
        try container.encode(productDescription, forKey: .productDescription)
        try container.encode(image, forKey: .image)
        try container.encode(price, forKey: .price)
    }
}
