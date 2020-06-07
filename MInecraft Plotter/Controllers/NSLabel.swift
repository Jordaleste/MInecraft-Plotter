//
//  NSLabel.swift
//  MInecraft Plotter
//
//  Created by Charles Eison on 6/7/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Cocoa

//Making our own NSLabel since is does not exist LMAO!
class NSLabel: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
