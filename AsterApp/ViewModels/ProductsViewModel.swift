//
//  ProductsViewModel.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import Foundation
import UIKit
import CoreData

class ProductsViewModel {
    
    // MARK:- properties
    private(set) var products : Dynamic<[Product]> = Dynamic<[Product]>([])
    private(set) var isLoadingPage = false
    private var canLoadMorePages = true
    private let manager:ProductsManager
    private let pageCount:Int
    private var cachedProducts = false
    private var maxProductId: Int? {
        return products.value.map{ Int($0.id) }.max()
    }
    var showLoadingIndicator: Bool {
        return canLoadMorePages && cachedProducts == false
    }
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK:- init
    init(manager:ProductsManager = ProductsManager(), pageCount:Int = 20 ){
        self.manager = manager
        self.pageCount = pageCount
        loadMoreContent(resetPaging: true)
    }
    
    /// Load more products pages
    /// - Parameter resetPaging: load products from the first page
    func loadMoreContent(resetPaging:Bool = false) {
        guard isLoadingPage == false && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        let fromProductId = resetPaging ? 0 : ( maxProductId ?? -1 ) + 1
        manager.getProducts(itemsCount: pageCount, from: fromProductId ){ result in
            self.isLoadingPage = false
            switch result {
            case .success(let newProducts):
                self.canLoadMorePages = ( newProducts.count == self.pageCount )
                self.cachedProducts = false
                if resetPaging {
                    self.products.value = newProducts
                } else {
                    self.products.value.append(contentsOf: newProducts)
                }
                self.saveProducts(clearCached: resetPaging)
            case .failure:
                if resetPaging { // get from cache if available
                    let cachedProducts = self.loadCachedProducts()
                    if cachedProducts.isEmpty == false {
                        self.cachedProducts = true
                        self.products.value = cachedProducts
                    }
                }
                break;
            }
        }
    }
    
    /// reload products if current products is cached Or there is no products loaded
    func reloadContentIfNeeded(){
        if cachedProducts || products.value.isEmpty {
            loadMoreContent(resetPaging:true)
        }
    }
    
    // MARK:- Caching
    @discardableResult
    private func saveProducts(clearCached:Bool = false) -> Bool {
        if clearCached {
            self.clearCachedProducts()
        }
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
            return true
          } catch let error as NSError {
           print("Failed saving  \(error), \(error.userInfo)")
            return false
        }
    }
    
    private func loadCachedProducts() -> [Product] {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        do {
            return try managedContext.fetch(fetchRequest) as? [Product] ?? []
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    @discardableResult
    private func clearCachedProducts() -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Product")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try appDelegate.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: appDelegate.persistentContainer.viewContext)
            return true
        } catch let error as NSError {
            print("Failed clearing cach  \(error), \(error.userInfo)")
            return false
        }
    }
    
}
