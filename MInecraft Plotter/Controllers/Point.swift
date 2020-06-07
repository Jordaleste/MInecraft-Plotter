//
//  Point.swift
//  MInecraft Plotter
//
//  Created by Charles Eison on 6/7/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Cocoa


//We are subclassing NSView to enable mouse events on NSViews, which are normally disabled.

class Point: NSView {
    
    let associatedWayPoint: WayPoint
    
    init(waypoint: WayPoint, frame frameRect: NSRect) {
        associatedWayPoint = waypoint
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //overrides NSView mouseup event to do what we want when we click
    
    override func mouseUp(with event: NSEvent) {
        let alert = NSAlert()
        alert.messageText = "Delete waypoint?"
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: self.window!) { (response) in
            guard response == .alertFirstButtonReturn else {
                return
            }
            
            DataController.shared.delete(waypoint: self.associatedWayPoint)
        }
    }
    
}
