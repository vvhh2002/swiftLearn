//
//  SuggestedSnapsWindowController.swift
//  DesktopSplitter
//
//  Created by Patrice Vignola on 3/2/18.
//  Copyright © 2018 Patrice Vignola. All rights reserved.
//

import Cocoa

class SuggestedSnapsWindowController: NSWindowController {
    private var suggestedSnapsViewController: SuggestedSnapsViewController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.isOpaque = false
        window?.alphaValue = 0
        
        suggestedSnapsViewController = contentViewController as? SuggestedSnapsViewController
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        // TODO: Disable the input to make sure the usre doesn't accidentally select another window during the fadein
        animateWindow(toAlpha: 1, forDurationInSeconds: 0.5, withCallback: nil)
    }
    
    func setSuggestedSnapDirection(_ suggestedSnapDirection: SnapHelper.SnapDirection) {
        if suggestedSnapDirection != .FullScreen, let window = window {
            // NSWindow's origin is its bottom-left corner
            var snapshotRect = SnapHelper.getSnapRect(for: suggestedSnapDirection, withOriginAt: .BottomLeft)
            
            if let mainMenu = NSApplication.shared.mainMenu {
                snapshotRect.origin.y += mainMenu.menuBarHeight
            }
            
            window.setFrame(snapshotRect, display: true)
            suggestedSnapsViewController?.setSuggestedSnapDirection(suggestedSnapDirection)
            suggestedSnapsViewController?.delegate = self
            
            NSApplication.shared.runModal(for: window)
            
            // TODO: Disable the input to make sure the user doesn't select another window during the fadeout
            animateWindow(toAlpha: 0, forDurationInSeconds: 0.5, withCallback: window.close)
        }
        
        dismissController(self)
    }
    
    private func animateWindow(toAlpha alpha: CGFloat, forDurationInSeconds duration: TimeInterval,
                               withCallback callback: (() -> Void)?) {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = duration
            window?.animator().alphaValue = alpha
        }, completionHandler: callback)
    }
}

extension SuggestedSnapsWindowController: NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        NSApplication.shared.stopModal()
    }
}

extension SuggestedSnapsWindowController: SuggestedSnapsViewControllerDelegate {
    func viewControllerDidSnapWindow() {
        NSApplication.shared.stopModal()
    }
    
    func viewControllerDidCancel() {
        NSApplication.shared.stopModal()
    }
}
