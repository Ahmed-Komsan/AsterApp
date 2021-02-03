//
//  ProductsCollectionViewController.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 31/01/2021.
//

import UIKit

enum ProductsSection : Int {
    case products
}

class ProductsViewController: UICollectionViewController, ReachabilityManagerObserver {
    
    // MARK:- properties
    private var viewModel: ProductsViewModel
    var imageLoader: ImageLoader
    
    typealias DataSource = UICollectionViewDiffableDataSource<ProductsSection, Product>
    private lazy var dataSource = makeDataSource()
    typealias Snapshot = NSDiffableDataSourceSnapshot<ProductsSection, Product>
    
    // MARK:- View LifeCycle
    required init(viewModel:ProductsViewModel = ProductsViewModel(), imageLoader: ImageLoader = ImageLoader.shared ){
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        let flowLayout = ProductsLayout()
        super.init(collectionViewLayout: flowLayout)
        collectionView.register(ProductCollectionCell.self, forCellWithReuseIdentifier: ProductCollectionCell.reuseIdentifier)
        collectionView.register(LoadingReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,withReuseIdentifier: LoadingReusableView.reuseIdentifier)
        self.title = "Products"
        self.view.backgroundColor = .systemBackground
        self.collectionView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? ProductsLayout {
            layout.delegate = self
        }
        applySnapshot(animatingDifferences: false)
        self.viewModel.products.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.applySnapshot(animatingDifferences: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeObserver(self)
    }
    
    // MARK:- DataSource
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: {( collectionView, indexPath, product) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.reuseIdentifier, for: indexPath) as? ProductCollectionCell
            cell?.configure(with: product, imageLoader: self.imageLoader)
            
            if let cachedImage = self.imageLoader.cachedImage(for: product.image?.url ?? ""){
                cell?.productImageView.image = cachedImage
            } else {
                self.imageLoader.downloadImage(with: product.image!.url! ){ [weak self] image in
                    if let updatedCell = self?.collectionView.cellForItem(at: indexPath) as? ProductCollectionCell {
                        updatedCell.productImageView.image = image
                    }
                }
            }
            
            return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else {
                return nil
            }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.reuseIdentifier,for: indexPath) as? LoadingReusableView
            view?.configure()
            return view
        }
        
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections( [ProductsSection.products] )
        snapshot.appendItems(viewModel.products.value, toSection: .products)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            viewModel.loadMoreContent()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = viewModel.products.value[indexPath.row]
        let productDetailsVC = ProductDetailsViewController(with: ProductDetailsViewModel(product: selectedProduct) )
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
    // MARK:- ReachabilityManagerObserver
    func reachabilityDidChange(to type: ConnectionType, isConnected: Bool) {
        if isConnected {
            viewModel.reloadContentIfNeeded()
        }
    }
    
}

extension ProductsViewController: ProductsLayoutDelegate {
    
    func shouldShowFooter() -> Bool {
        return viewModel.showLoadingIndicator
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, columnWidth: CGFloat) -> CGFloat {
        
        let productDescriptionLabel = UILabel()
        productDescriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        productDescriptionLabel.numberOfLines = 0
        productDescriptionLabel.text = viewModel.products.value[indexPath.item].productDescription
        let expectedLabelHeight = productDescriptionLabel.sizeThatFits( CGSize(width: columnWidth, height: CGFloat.greatestFiniteMagnitude) ).height + 60
        return CGFloat(viewModel.products.value[indexPath.item].image!.height) + expectedLabelHeight
    }
}
