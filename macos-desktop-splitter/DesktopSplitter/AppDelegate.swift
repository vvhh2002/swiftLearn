//
//  AppDelegate.swift
//  DesktopSplitter
//
//  Created by Patrice Vignola on 2/26/18.
//  Copyright © 2018 Patrice Vignola. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak private var mainMenu: NSMenu!
    var statusItem: NSStatusItem?
    
    var snapDirection = SnapHelper.SnapDirection.None
    var modifiersMonitor: Any?
    var keyDownMonitor: Any?
    var keyWindow: DesktopWindow?
    
    private let statusBarImageName = "Windows.png"
    
    private func handleKeyPress(_ event: NSEvent) {
        guard !event.isARepeat else { return }
        
        let keyCode = Int(event.charactersIgnoringModifiers!.unicodeScalars.first!.value)
        snapDirection = SnapHelper.getNextSnapDirection(fromPrevious: snapDirection, withArrowCode: keyCode)
        
        if snapDirection != .None {
            snapKeyWindow()
        }
    }
    
    private func handleModifierKeys(_ event: NSEvent) {
        // TODO: Let the user customize the modifier keys instead of hardcoding them
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.control, .option]:
            // If the user hasn't enabled the accessibility features for the app yet, we don't want to spam him by
            // showing the dialog box another time. This is why we don't use AXIsProcessTrustedWithOptions().
            if AXIsProcessTrusted() && keyDownMonitor == nil {
                keyDownMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: handleKeyPress)
                keyWindow = (DesktopWindow.getOpenedWindows(includeMinimized: false).filter { $0.isKey }).first
            }
        default:
            if let keyDownMonitor = keyDownMonitor {
                NSEvent.removeMonitor(keyDownMonitor)
                self.keyDownMonitor = nil
                handleModifierKeysReleased()
            }
        }
    }
    
    private func handleModifierKeysReleased() {
        guard snapDirection != .None && snapDirection != .FullScreen else { return }
        
        let suggestedSnapDirection = SnapHelper.getMirror(of: snapDirection)
        snapDirection = .None
        showSuggestedSnapsWindow(to: suggestedSnapDirection)
    }
    
    private func snapKeyWindow() {
        guard snapDirection != .None else { return }
        
        keyWindow?.set(frame: SnapHelper.getSnapRect(for: snapDirection, withOriginAt: .TopLeft))
    }
    

    private func showSuggestedSnapsWindow(to suggestedSnapDirection: SnapHelper.SnapDirection) {
        let openedWindows = DesktopWindow.getOpenedWindows(includeMinimized: false)
        
        if openedWindows.count > 1 {
            let sb = NSStoryboard(name: "Main", bundle: nil)
            let controllerId = "SuggestedSnapsWindowController"
            let controller = sb.instantiateController(withIdentifier: controllerId) as! SuggestedSnapsWindowController
            
            // TODO: Pass the opened windows to the controller and don't fetch them again when the controller loads
            controller.setSuggestedSnapDirection(suggestedSnapDirection)
            
            // Once the suggested snaps window has been closed, we bring back the main window to front so that the
            // user's workflow is not interrupted and he doesn't need to manually bring it back to front
            keyWindow?.makeKey()
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as CFString: true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
        modifiersMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: handleModifierKeys)
        
        initStatusItem()
    }
    
    private func initStatusItem() {
        // Create a status bar with variable length
        statusItem = NSStatusBar.system.statusItem(withLength: -1)
        
        // Set the text that appears in the menu bar
        statusItem?.image = NSImage(named: "Windows.png")
        statusItem?.image?.size = NSSize(width: 20, height: 20)
        statusItem?.length = 30
        // image should be set as tempate so that it changes when the user sets the menu bar to a dark theme
        statusItem?.image?.isTemplate = true
        
        // Set the menu that should appear when the item is clicked
        statusItem?.menu = mainMenu
        
        // Set if the item should change color when clicked
        statusItem?.highlightMode = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        if let modifiersMonitor = modifiersMonitor {
            NSEvent.removeMonitor(modifiersMonitor)
            self.modifiersMonitor = nil
        }
    }
}
