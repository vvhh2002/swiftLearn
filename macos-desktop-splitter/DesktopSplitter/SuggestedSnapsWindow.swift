//
//  SuggestedSnapsWindow.swift
//  DesktopSplitter
//
//  Created by Patrice Vignola on 3/2/18.
//  Copyright © 2018 Patrice Vignola. All rights reserved.
//

import Cocoa

class SuggestedSnapsWindow: NSWindow {
    override func center() {
        // Do nothing; we don't want the window at the center of the screen when it's modal
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
    
    override var animationBehavior: NSWindow.AnimationBehavior {
        get {
            // The WindowController controls the animations of its window
            return NSWindow.AnimationBehavior.none
        }
        
        set {
            super.animationBehavior = newValue
        }
    }
}
