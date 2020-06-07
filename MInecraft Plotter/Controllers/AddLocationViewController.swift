//
//  AddLocationViewController.swift
//  MInecraft Plotter
//
//  Created by Charles Eison on 6/6/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Cocoa

class AddLocationViewController: NSViewController {
    
    let titleString: String
    let type: WayPointType
    lazy var xCoordinateField = NSTextField()
    lazy var yCoordinateField = NSTextField()
    lazy var zCoordinateField = NSTextField()
    lazy var commentsField = NSTextField()
    
    init(title: String, type: WayPointType) {
        titleString = title
        self.type = type
        //Have to call super.init because we are subclassing and creating our own init
        super.init(nibName: nil, bundle: nil)
    }
        //required for storyboard, even though we are not using it. Standard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        
        let coordinateStackView = NSStackView()
        coordinateStackView.orientation = .horizontal
        coordinateStackView.distribution = .fillEqually
        coordinateStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coordinateStackView)
        
        NSLayoutConstraint.activate([
            coordinateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            coordinateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            coordinateStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ])
        
        xCoordinateField.placeholderString = "x"
        yCoordinateField.placeholderString = "y"
        zCoordinateField.placeholderString = "z"
        
        coordinateStackView.addArrangedSubview(xCoordinateField)
        coordinateStackView.addArrangedSubview(yCoordinateField)
        coordinateStackView.addArrangedSubview(zCoordinateField)
        
        commentsField.translatesAutoresizingMaskIntoConstraints = false
        commentsField.placeholderString = "Comments"
        
        view.addSubview(commentsField)
        
        NSLayoutConstraint.activate([
            commentsField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            commentsField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            commentsField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        
        let doneButton = NSButton(title: "Done", target: self, action: #selector(doneButtonPressed))
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                
        ])
        let formatter = OnlyIntegerValueFormatter()
        xCoordinateField.formatter = formatter
        yCoordinateField.formatter = formatter
        zCoordinateField.formatter = formatter
    }
    
    override func viewDidAppear() {
        self.view.window?.title = titleString
    }
    
    
    @objc func doneButtonPressed() {
        
        let x = Int(xCoordinateField.stringValue)!
        let y = Int(yCoordinateField.stringValue)!
        let z = Int(zCoordinateField.stringValue)!
        let comment = commentsField.stringValue
        
        DataController.shared.createWayPoint(x: x, y: y, z: z, comment: comment, type: type)
        view.window?.close()
    }
}

 class OnlyIntegerValueFormatter: NumberFormatter {

    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        // Ability to reset your field (otherwise you can't delete the content)
        // You can check if the field is empty later
        if partialString.isEmpty {
            return true
        }

        // Optional: limit input length
        /*
        if partialString.characters.count>3 {
            return false
        }
        */

        // Actual check
        if partialString == "-" {
            return true
        }
        return Int(partialString) != nil
    }
}
