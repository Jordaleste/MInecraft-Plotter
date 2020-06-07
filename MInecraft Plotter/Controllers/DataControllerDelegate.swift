//
//  DataControllerDelegate.swift
//  MInecraft Plotter
//
//  Created by Charles Eison on 6/7/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation

protocol DataControllerDelegate {
    
    func dataControllerDidGetUpdates(waypoints: [WayPoint])
    
}
