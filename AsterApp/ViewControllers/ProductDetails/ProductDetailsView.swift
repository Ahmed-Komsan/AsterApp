//
//  ProductDetailsView.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 03/02/2021.
//

import UIKit

class ProductDetailsView: UIView {
    
    lazy var productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        return productImageView
    }()
    
    lazy var productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        productPriceLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        productPriceLabel.backgroundColor = .white
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return productPriceLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView(){
        
        self.backgroundColor = .systemBackground
        self.addSubview(productImageView)
        self.addSubview(productPriceLabel)
        self.setupLayout()
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            productImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 300),
            
            productPriceLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            productPriceLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8)
        ])
    }
}
