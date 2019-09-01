//
//  SnapHelper.swift
//  DesktopSplitter
//
//  Created by Patrice Vignola on 3/4/18.
//  Copyright © 2018 Patrice Vignola. All rights reserved.
//

import Cocoa

class SnapHelper {
    public enum SnapDirection {
        case None, FullScreen, Left, Right, Top, Bottom, TopLeft, TopRight, BottomLeft, BottomRight
    }
    
    public enum OriginLocation {
        case TopLeft, BottomLeft
    }
    
    static func getSnapRect(for snapDirection: SnapDirection, withOriginAt originLocation: OriginLocation) -> NSRect {
        // TODO: Add support for multiple screens
        // TODO: Maybe return nil instead of default NSRect()
        guard let screen = NSScreen.main?.visibleFrame else { return NSRect() }
        
        var snapRect = NSRect()
        
        // TODO: Check if it still works if the dock menu is vertical (left or right of the screen)
        // TODO: Fix the height/origin when the dock is shown at the bottom of the screen
        let minX = screen.minX
        var minY: CGFloat = 0.0
        let height = screen.height
        
        if let mainMenu = NSApplication.shared.mainMenu {
            minY += mainMenu.menuBarHeight
        }
        
        switch snapDirection {
        case .FullScreen:
            snapRect.origin = NSPoint(x: minX, y: minY)
            snapRect.size = NSSize(width: screen.width, height: height)
        case .Left:
            snapRect.origin = NSPoint(x: minX, y: minY)
            snapRect.size = NSSize(width: screen.width / 2, height: height)
        case .Right:
            snapRect.origin = NSPoint(x: minX + screen.width / 2, y: minY)
            snapRect.size = NSSize(width: screen.width / 2, height: height)
        case .Top:
            snapRect.origin = NSPoint(x: minX, y: minY)
            snapRect.size = NSSize(width: screen.width, height: height / 2)
        case .Bottom:
            snapRect.origin = NSPoint(x: minX, y: minY + height / 2)
            snapRect.size = NSSize(width: screen.width, height: height / 2)
        case .TopLeft:
            snapRect.origin = NSPoint(x: minX, y: minY)
            snapRect.size = NSSize(width: screen.width / 2, height: height / 2)
        case .TopRight:
            snapRect.origin = NSPoint(x: minX + screen.width / 2, y: minY)
            snapRect.size = NSSize(width: screen.width / 2, height: height / 2)
        case .BottomLeft:
            snapRect.origin = NSPoint(x: minX, y: minY + height / 2)
            snapRect.size = NSSize(width: screen.width / 2, height: height / 2)
        case .BottomRight:
            snapRect.origin = NSPoint(x: minX + screen.width / 2, y: minY + height / 2)
            snapRect.size = NSSize(width: screen.width / 2, height: height / 2)
        default:
            break
        }
        
        if originLocation == .BottomLeft {
            // Convert to a rect with its origin at the bottom-left corner
            snapRect.origin.y = screen.height - snapRect.height - snapRect.origin.y
        }
        
        return snapRect
    }
    
    static func getMirror(of snapDirection: SnapDirection) -> SnapDirection {
        switch snapDirection {
        case .None:
            return .None
        case .FullScreen:
            return .None
        case .Left:
            return .Right
        case .Right:
            return .Left
        case .Top:
            return .Bottom
        case .Bottom:
            return .Top
        case .TopLeft:
            return .BottomLeft
        case .TopRight:
            return .BottomRight
        case .BottomLeft:
            return .TopLeft
        case .BottomRight:
            return .TopRight
        }
    }
    
    static func getNextSnapDirection(fromPrevious previousSnapDirection: SnapDirection,
                                      withArrowCode arrowCode: Int) -> SnapDirection {
        var nextSnapDirection = previousSnapDirection
        
        switch arrowCode {
        case NSEvent.SpecialKey.rightArrow.rawValue:
            switch previousSnapDirection {
            case .None, .FullScreen, .Left, .BottomLeft, .TopLeft, .BottomRight, .TopRight, .Right:
                nextSnapDirection = .Right
            case .Bottom:
                nextSnapDirection = .BottomRight
            case .Top:
                nextSnapDirection = .TopRight
            }
        case NSEvent.SpecialKey.leftArrow.rawValue:
            switch previousSnapDirection {
            case .None, .FullScreen, .Right, .BottomLeft, .TopLeft, .BottomRight, .TopRight, .Left:
                nextSnapDirection = .Left
            case .Bottom:
                nextSnapDirection = .BottomLeft
            case .Top:
                nextSnapDirection = .TopLeft
            }
        case NSEvent.SpecialKey.upArrow.rawValue:
            switch previousSnapDirection {
            case .None, .Bottom, .BottomLeft, .BottomRight, .TopLeft, .TopRight, .FullScreen:
                nextSnapDirection = .Top
            case .Left:
                nextSnapDirection = .TopLeft
            case .Right:
                nextSnapDirection = .TopRight
            case .Top:
                nextSnapDirection = .FullScreen
            }
        case NSEvent.SpecialKey.downArrow.rawValue:
            switch previousSnapDirection {
            case .None, .Top, .BottomLeft, .BottomRight, .TopLeft, .TopRight, .FullScreen:
                nextSnapDirection = .Bottom
            case .Left:
                nextSnapDirection = .BottomLeft
            case .Right:
                nextSnapDirection = .BottomRight
            case .Bottom:
                // TODO: Add a "Minimized" snap direction
                nextSnapDirection = .Bottom
            }
        default:
            break
        }
        
        return nextSnapDirection
    }
}
