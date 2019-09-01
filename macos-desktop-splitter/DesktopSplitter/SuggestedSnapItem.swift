//
//  SuggestedSnapItem.swift
//  DesktopSplitter
//
//  Created by Patrice Vignola on 2/27/18.
//  Copyright © 2018 Patrice Vignola. All rights reserved.
//

import Cocoa

class SuggestedSnapItem: NSCollectionViewItem {
    @IBOutlet weak private var icon: NSImageView?

    private let defaultBackgroundColor = NSColor(calibratedWhite: 0, alpha: 0)
    private let hoverBackgroundColor = NSColor(calibratedWhite: 0, alpha: 0.7)
 
    override func mouseEntered(with event: NSEvent) {
        // TODO: Animate the opacity fade-in
        view.layer?.backgroundColor = hoverBackgroundColor.cgColor
    }
    
    override func mouseExited(with event: NSEvent) {
        // TODO: Animate the opacity fade-out
        view.layer?.backgroundColor = defaultBackgroundColor.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = defaultBackgroundColor.cgColor
        
        let options = NSTrackingArea.Options.activeAlways.union(.mouseEnteredAndExited).union(.inVisibleRect)
        view.addTrackingArea(NSTrackingArea(rect: NSRect(), options: options, owner: self))
    }
    
    var suggestedSnap: DesktopWindow? {
        didSet {
            guard isViewLoaded else { return }
            
            if suggestedSnap != nil {
                imageView?.image = suggestedSnap!.screenshot
                textField?.stringValue = suggestedSnap!.title
                icon?.image = suggestedSnap!.icon
            }
        }
    }
}
