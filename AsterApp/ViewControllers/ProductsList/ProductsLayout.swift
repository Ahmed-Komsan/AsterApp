//
//  ProductsLayout.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 31/01/2021.
//

import UIKit

protocol ProductsLayoutDelegate: AnyObject {
    func collectionView( _ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, columnWidth:CGFloat) -> CGFloat
    func shouldShowFooter() -> Bool
}

class ProductsLayout: UICollectionViewLayout {
    
    weak var delegate: ProductsLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private let footerHeight: CGFloat = 60
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // current collectionview content height
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // size of the collection view’s contents
    override var collectionViewContentSize: CGSize {
        if let showFooter = delegate?.shouldShowFooter(), showFooter == true  {
            return CGSize(width: contentWidth, height: contentHeight + footerHeight )
        }
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView, cache.count != collectionView.numberOfItems(inSection: 0) else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for columnIdx in 0..<numberOfColumns {
            xOffset.append(CGFloat(columnIdx) * columnWidth)
        }
        var columnIdx = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var updatedContentHeight: CGFloat = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView( collectionView, heightForItemAtIndexPath: indexPath, columnWidth: columnWidth) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[columnIdx],y: yOffset[columnIdx],width: columnWidth,height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            updatedContentHeight = max(updatedContentHeight, frame.maxY)
            yOffset[columnIdx] = yOffset[columnIdx] + height
            
            columnIdx = columnIdx < (numberOfColumns - 1) ? (columnIdx + 1) : 0
        }
        
        contentHeight = updatedContentHeight
    }
    
    /// collection view calls it after prepare() to determine which items are visible in the given rectangle.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        let footerIndexPath = IndexPath(item: collectionView?.numberOfItems(inSection: 0) ?? 0, section: 0)
        if let attribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: footerIndexPath), attribute.frame.intersects(rect) {
            visibleLayoutAttributes.append(attribute)
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let showFooter = delegate?.shouldShowFooter(), showFooter == true else {
            return nil
        }
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attributes.size = CGSize(width: (self.collectionView?.bounds.size.width)!, height: footerHeight)
        attributes.frame = CGRect(origin:  CGPoint(x: (self.collectionView?.contentOffset.x)! , y: contentHeight ) , size: attributes.size)
        return attributes
    }
}
