//
//  ProductDetailsViewController.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 03/02/2021.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    private lazy var productDetailsView: ProductDetailsView = {
        let mainView = ProductDetailsView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    private var viewModel: ProductDetailsViewModel
    
    required init(with viewModel: ProductDetailsViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(productDetailsView)
        NSLayoutConstraint.activate([
            productDetailsView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productDetailsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            productDetailsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            productDetailsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Product Details"
        self.setupView()
    }
    
    func setupView(){
        self.productDetailsView.productPriceLabel.text = viewModel.productPrice
        ImageLoader.shared.downloadImage(with: viewModel.productImageUrl ){ [weak self] image in
            self?.productDetailsView.productImageView.image = image
        }
    }
    
}
