//
//  LoadingCollectionReusableView.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 31/01/2021.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: LoadingReusableView.self)
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(activityIndicator)
        setupLayout()
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configure(){
        self.activityIndicator.startAnimating()
    }

}
