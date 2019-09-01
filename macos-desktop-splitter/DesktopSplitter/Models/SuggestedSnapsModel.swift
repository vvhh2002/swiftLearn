//
//  SuggestedSnapsModel.swift
//  DesktopSplitter
//
//  Created by Patrice Vignola on 3/1/18.
//  Copyright © 2018 Patrice Vignola. All rights reserved.
//

import Cocoa

class SuggestedSnapsModel {
    var suggestedSnapDirection = SnapHelper.SnapDirection.None
    private var suggestedSnaps = [DesktopWindow]()
    private var indexPaths: Set<IndexPath> = []
    
    func add(newSuggestedSnap: DesktopWindow) {
        suggestedSnaps.append(newSuggestedSnap)
        indexPaths.insert(IndexPath(item: indexPaths.count, section: 0))
    }
    
    func add(newSuggestedSnaps: [DesktopWindow]) {
        for newSuggestedSnap in newSuggestedSnaps {
            add(newSuggestedSnap: newSuggestedSnap)
        }
    }
    
    func getSuggestedSnap(at index:Int) -> DesktopWindow {
        return suggestedSnaps[index]
    }
    
    func getIndexPaths() -> Set<IndexPath> {
        return indexPaths
    }
    
    var numSuggestedSnaps: Int {
        return suggestedSnaps.count
    }
}
