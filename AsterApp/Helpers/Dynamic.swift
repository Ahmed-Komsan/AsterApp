//
//  Dynamic.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import UIKit

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    init(_ v: T) {
        value = v
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
  
}
