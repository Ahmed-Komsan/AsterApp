//
//  XCTestCase.swift
//  AsterAppTests
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import XCTest

extension XCTestCase {

    func loadStub(name: String, fileExtension: String) -> Data {
        
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: fileExtension)
        return try! Data(contentsOf: url!)
    }
    
}
