//
//  DataController.swift
//  MInecraft Plotter
//
//  Created by Charles Eison on 6/6/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation
import CoreData
import Cocoa

class DataController {
    
    static var shared = DataController()
    
    var delegate: DataControllerDelegate?
    
    //this grabs the persistentContainer from AppDelegate so we can use it to save to
    private let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createWayPoint(x: Int, y: Int, z: Int, comment: String, type: WayPointType) {
        let newWaypoint = WayPoint(context: self.context)
        newWaypoint.x = Int64(x)
        newWaypoint.y = Int64(y)
        newWaypoint.z = Int64(z)
        newWaypoint.comment = comment
        newWaypoint.type = type.rawValue
        
        self.saveData()
    }
    
    func fetchData() {
        
        let request: NSFetchRequest<WayPoint> = WayPoint.fetchRequest()
        
        do {
            let wayPointsArray = try context.fetch(request)
            delegate?.dataControllerDidGetUpdates(waypoints: wayPointsArray)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    private func saveData() {
        
        if context.hasChanges {
            do {
                try context.save()
                fetchData()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    func delete(waypoint: WayPoint) {
        context.delete(waypoint)
        saveData()
    }
}
