//
//  ProductDetailsViewModel.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 03/02/2021.
//

import UIKit

class ProductDetailsViewModel {

    private var product: Product
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    init(product:Product ){
        self.product = product
    }
    
    var productPrice: String?  {
        return formatter.string(from: NSNumber(integerLiteral: Int(product.price)))
    }
    
    var productImageUrl: String  {
        return product.image?.url ?? ""
    }
}
