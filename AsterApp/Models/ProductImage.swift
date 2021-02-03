//
//  ProductImage.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import Foundation
import CoreData

class ProductImage: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
    }
    
    @NSManaged public var height: Int
    @NSManaged public var url: String?
    @NSManaged public var width: Int
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(url, forKey: .url)
    }
}
