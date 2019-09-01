//
//  SuggestedSnapsView.swift
//  DesktopSplitter
//
//  Created by Patrice Vignola on 3/1/18.
//  Copyright © 2018 Patrice Vignola. All rights reserved.
//

import Cocoa

class SuggestedSnapsView: NSCollectionView {
    @IBOutlet weak private var flowLayout: NSCollectionViewFlowLayout?
    
    private var trackingArea: NSTrackingArea?
    var focusedIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let flowLayout = flowLayout else { return }
        
        flowLayout.sectionInset = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.minimumLineSpacing = 30
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        updateItemSize()
    }
    
    private func updateItemSize() {
        guard let flowLayout = flowLayout else { return }
        
        let numItems = numberOfItems(inSection: 0)
        
        var maxContentWidth = frame.width
        maxContentWidth -= flowLayout.sectionInset.left + flowLayout.sectionInset.right
        maxContentWidth += flowLayout.minimumInteritemSpacing
        
        var maxContentHeight = frame.height
        maxContentHeight -= flowLayout.sectionInset.top + flowLayout.sectionInset.bottom
        maxContentHeight += flowLayout.minimumLineSpacing
        
        var itemSize = getItemSize(forNumItems: numItems, forWidth: maxContentWidth, forHeight: maxContentHeight)
        itemSize.width -= flowLayout.minimumInteritemSpacing
        itemSize.height -= flowLayout.minimumLineSpacing
        
        flowLayout.itemSize = itemSize
    }
    
    override func makeItem(withIdentifier identifier: NSUserInterfaceItemIdentifier,
                           for indexPath: IndexPath) -> NSCollectionViewItem {
        let item = super.makeItem(withIdentifier: identifier, for: indexPath)
        
        if focusedIndexPath == nil {
            (delegate as? SuggestedSnapsViewDelegate)?.collectionView(self, didFocusItem: item)
            focusedIndexPath = indexPath
        }
        
        return item
    }
    
    override func moveLeft(_ sender: Any?) {
        incrementFocusedIndex(by: -1)
    }
    
    override func moveRight(_ sender: Any?) {
        incrementFocusedIndex(by: 1)
    }
    
    override func moveUp(_ sender: Any?) {
        // TODO: Decrement the index by the number of columns
    }
    
    override func moveDown(_ sender: Any?) {
        // TODO: Increment the index by the number of columns
    }
    
    override func insertNewline(_ sender: Any?) {
        if let focusedIndexPath = focusedIndexPath {
            delegate?.collectionView!(self, didSelectItemsAt: [focusedIndexPath])
        }
    }
    
    private func incrementFocusedIndex(by increment: Int) {
        guard let delegate = delegate as? SuggestedSnapsViewDelegate else { return }
        guard let focusedIndexPath = focusedIndexPath else { return }
        
        let newFocusedIndexPath = IndexPath(item: focusedIndexPath.item + increment, section: focusedIndexPath.section)
        
        if let newFocusedItem = item(at: newFocusedIndexPath) {
            delegate.collectionView(self, didFocusItem: newFocusedItem)
            
            if let oldFocusedItem = item(at: focusedIndexPath) {
                delegate.collectionView(self, didUnfocusItem: oldFocusedItem)
            }
            
            self.focusedIndexPath = newFocusedIndexPath
        }
    }
    
    // TODO: Delete once the optimal size for every item has been calculated in the controller
    private func getItemSize(forNumItems numItems: Int, forWidth width: CGFloat, forHeight height: CGFloat) -> NSSize {
        let n = Double(numItems)
        let x = Double(width)
        let y = Double(height)
        
        let px = ceil(sqrt(n*x/y))
        
        var sx: Double = 0
        var sy: Double = 0
        
        if floor(px * y / x) * px < n { // Doesn't fit
            sx = y / ceil(px * y / x)
        } else {
            sx = x / px
        }
        
        let py = ceil(sqrt(n*y/x))
        
        if floor(py * x / y) * py < n { // Doesn't fit
            sy = x / ceil(x * py / y)
        } else {
            sy = y / py
        }
        
        return NSSize(width: sx, height: sy)
    }
}

protocol SuggestedSnapsViewDelegate : NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didUnfocusItem item: NSCollectionViewItem)
    func collectionView(_ collectionView: NSCollectionView, didFocusItem item: NSCollectionViewItem)
} 
