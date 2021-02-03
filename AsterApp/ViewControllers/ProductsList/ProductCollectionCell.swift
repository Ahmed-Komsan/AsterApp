//
//  ProductCollectionCell.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 31/01/2021.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    
    // MARK:- properties
    static var reuseIdentifier: String {
        return String(describing: ProductCollectionCell.self)
    }
    
    lazy var productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        return productImageView
    }()
    
    lazy var productDescriptionLabel: UILabel = {
        let productDescriptionLabel = UILabel()
        productDescriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        productDescriptionLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        productDescriptionLabel.numberOfLines = 0
        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return productDescriptionLabel
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        productPriceLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        productPriceLabel.backgroundColor = .white
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return productPriceLabel
    }()
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    private lazy var imageHeightConstraint = productImageView.heightAnchor.constraint(equalToConstant: 100)
    private var product:Product?
    
    // MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productDescriptionLabel)
        contentView.addSubview(productPriceLabel)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageHeightConstraint,
            
            productDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            productDescriptionLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 4),
            productDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            productPriceLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            productPriceLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8)
        ])
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        if let currentProduct = product {
            self.imageHeightConstraint.constant = CGFloat(currentProduct.image!.height)
        }
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return size
    }
    
    // MARK:- Configuration
    func configure(with product:Product, imageLoader:ImageLoader){
        self.productDescriptionLabel.text = product.productDescription
        self.productPriceLabel.text = formatter.string(from: NSNumber(integerLiteral: Int(product.price)))
        self.imageHeightConstraint.constant = CGFloat(product.image!.height)
        self.product = product
        self.productImageView.image = UIImage(named: "waiting") // placeholder
    }
    
    override func prepareForReuse() {
        self.productDescriptionLabel.text = ""
        self.productPriceLabel.text = ""
        self.productImageView.image = nil
    }
    
}
