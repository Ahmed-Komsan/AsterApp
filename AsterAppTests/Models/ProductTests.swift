//
//  ProductTests.swift
//  AsterAppTests
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import XCTest
import CoreData
@testable import AsterApp

class ProductTests: XCTestCase {
    
    // MARK: - Properties
    var products: [Product]!
    private let entityName = "Product"
    
    // MARK: mock in-memory persistant store
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AsterAppTests", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                XCTFail("Error creating the in-memory NSPersistentContainer mock: \(error)")
            }
        }

        return container
    }()
    
    override func setUpWithError() throws {
        // Load Stub
        let data = loadStub(name: "products", fileExtension: "json")
        // Decode JSON
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = mockPersistentContainer.viewContext
        products = try decoder.decode([Product].self, from: data)
    }
    
    func test_parsingModelData(){
        XCTAssertEqual(products.count,10)
        let product = products.first
        XCTAssertEqual(product?.id, 1)
        XCTAssertEqual(product?.productName, "Name-1")
        XCTAssertEqual(product?.productDescription, "Lorem ipsum dolor sit ametQSvAIVLc7m6c")
        XCTAssertEqual(product?.image?.width, 112)
        XCTAssertEqual(product?.image?.height, 191)
        XCTAssertEqual(product?.image?.url, "https://picsum.photos/112/191")
        XCTAssertEqual(product?.price, 276)
    }
    
    
    override func tearDownWithError() throws {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let cachedProducts = try mockPersistentContainer.viewContext.fetch(fetchRequest)
        for case let product as NSManagedObject in cachedProducts {
            mockPersistentContainer.viewContext.delete(product)
        }
        try mockPersistentContainer.viewContext.save()
    }

}
