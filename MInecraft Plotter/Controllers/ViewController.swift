//
//  ViewController.swift
//  MInecraft Plotter
//
//  Created by Charles Eison on 6/5/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    private var plottedWayPoints: [Point] = []
    private let leftLabel = NSLabel(frame: .zero)
    private let rightLabel = NSLabel(frame: .zero)
    private let topLabel = NSLabel(frame: .zero)
    private let bottomLabel = NSLabel(frame: .zero)
    
    private var scale: Double = 1 {
        didSet {
            sizeChanged()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataController.shared.delegate = self

        let verticalLine = NSView(frame: NSRect(x: view.frame.width / 2, y: 0, width: 1, height: view.frame.height))
        verticalLine.wantsLayer = true
        verticalLine.layer?.backgroundColor = NSColor.red.cgColor
        
        //this is for doing autolayout in code, must be done for *every* view used with autolayout
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verticalLine)
        
        let horizontalLine = NSView(frame: NSRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: 1))
        horizontalLine.wantsLayer = true
        horizontalLine.layer?.backgroundColor = NSColor.red.cgColor
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(horizontalLine)
        
        NSLayoutConstraint.activate([
            verticalLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalLine.heightAnchor.constraint(equalTo: view.heightAnchor),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            
            horizontalLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            horizontalLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            horizontalLine.widthAnchor.constraint(equalTo: view.widthAnchor),
            horizontalLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
        
        
        let buttonStackView = NSStackView()
        buttonStackView.orientation = .horizontal
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        
        let placeHouseButton = NSButton(image: NSImage(named: "house")!, target: self, action: #selector(houseButtonPressed))
        placeHouseButton.isTransparent = true
        placeHouseButton.bezelStyle = .regularSquare
        placeHouseButton.image?.size = CGSize(width: 50, height: 50)
        placeHouseButton.toolTip = "Place House"
        buttonStackView.addArrangedSubview(placeHouseButton)
        
        let placeVillageButton = NSButton(image: NSImage(named: "villager")!, target: self, action: #selector(villageButtonPressed))
        placeVillageButton.isTransparent = true
        placeVillageButton.bezelStyle = .regularSquare
        placeVillageButton.image?.size = CGSize(width: 50, height: 50)
        placeVillageButton.toolTip = "Place Village"
        buttonStackView.addArrangedSubview(placeVillageButton)
        
        let placeStructureButton = NSButton(image: NSImage(named: "structure")!, target: self, action: #selector(structureButtonPressed))
        placeStructureButton.isTransparent = true
        placeStructureButton.bezelStyle = .regularSquare
        placeStructureButton.image?.size = CGSize(width: 50, height: 50)
        placeStructureButton.toolTip = "Place Structure"
        buttonStackView.addArrangedSubview(placeStructureButton)
        
        let slider = NSSlider(value: 1, minValue: 0.0001, maxValue: 1.5, target: self, action: #selector(sliderValueChanged(_:)))
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            slider.widthAnchor.constraint(equalToConstant: 300),
            slider.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(sizeChanged), name: NSWindow.didResizeNotification, object: nil)
        
        
        requestWayPoints()
    }
    
    @objc func sizeChanged() {
        print("did resize")
        leftLabel.removeFromSuperview()
        rightLabel.removeFromSuperview()
        topLabel.removeFromSuperview()
        bottomLabel.removeFromSuperview()
        
        leftLabel.stringValue = "-\(Int((view.bounds.width / 2) / CGFloat(scale)))"
        rightLabel.stringValue = "\(Int((view.bounds.width / 2) / CGFloat(scale)))"
        topLabel.stringValue = "-\(Int((view.bounds.height / 2) / CGFloat(scale)))"
        bottomLabel.stringValue = "\(Int((view.bounds.height / 2) / CGFloat(scale)))"
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            leftLabel.heightAnchor.constraint(equalToConstant: 30),
            
            rightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            rightLabel.heightAnchor.constraint(equalToConstant: 30),
            
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            topLabel.heightAnchor.constraint(equalToConstant: 30),
            
            bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomLabel.heightAnchor.constraint(equalToConstant: 30)
        
        ])
    }
    
    override func viewDidAppear() {
        
        print(view.intrinsicContentSize)
    }

    
    
    @objc func houseButtonPressed() {
        
        let houseWindow = NSWindow(contentRect: NSRect(origin: .zero, size: .zero), styleMask: [.titled, .resizable, .closable], backing: .buffered, defer: false)

        houseWindow.contentViewController = AddLocationViewController(title: "Place House", type: .house)
        houseWindow.center()
        houseWindow.isReleasedWhenClosed = false
        houseWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func villageButtonPressed() {
        
        let villageWindow = NSWindow(contentRect: NSRect(origin: .zero, size: .zero), styleMask: [.titled, .resizable, .closable], backing: .buffered, defer: false)

        villageWindow.contentViewController = AddLocationViewController(title: "Place Village", type: .village)
        villageWindow.center()
        villageWindow.isReleasedWhenClosed = false
        villageWindow.makeKeyAndOrderFront(nil)
    }

    @objc func structureButtonPressed() {
        
        let structureWindow = NSWindow(contentRect: NSRect(origin: .zero, size: .zero), styleMask: [.titled, .resizable, .closable], backing: .buffered, defer: false)

        structureWindow.contentViewController = AddLocationViewController(title: "Place Structure", type: .structure)
        structureWindow.center()
        structureWindow.isReleasedWhenClosed = false
        structureWindow.makeKeyAndOrderFront(nil)
        
    }
    
    @objc func sliderValueChanged(_ sender: NSSlider) {
        
        let waypoints = plottedWayPoints.map {$0.associatedWayPoint}
        plottedWayPoints.forEach { (point) in
            point.removeFromSuperview()
        }
        
        plottedWayPoints = []
        for waypoint in waypoints {
            guard let typeString = waypoint.type, let type = WayPointType(rawValue: typeString) else { fatalError("Unable to convert type")}
            plot(waypoint: waypoint, type: type, scale: sender.doubleValue)
        }
        
        scale = sender.doubleValue
    }
    
    func requestWayPoints() {
        DataController.shared.fetchData()
    }
    
    func plot(waypoint: WayPoint, type: WayPointType, scale: Double = 1) {
        
        let point = Point(waypoint: waypoint, frame: NSRect(origin: .zero, size: CGSize(width: 10, height: 10)))
        point.wantsLayer = true
        
        point.layer?.cornerRadius = 5
        point.translatesAutoresizingMaskIntoConstraints = false
        
        let color: CGColor
        switch type {
        case .house:
            color = NSColor.systemGreen.cgColor
        case .structure:
            color = NSColor.systemRed.cgColor
        case .village:
            color = NSColor.systemBlue.cgColor
        }
        point.layer?.backgroundColor = color
        
        view.addSubview(point)
        plottedWayPoints.append(point)
        
        NSLayoutConstraint.activate([
            point.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CGFloat(Double(waypoint.x) * scale)),
            point.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(Double(waypoint.z) * scale)),
            point.widthAnchor.constraint(equalToConstant: 10),
            point.heightAnchor.constraint(equalToConstant: 10)
        
        ])
        
        point.toolTip = """
        \(waypoint.type!.capitalized)
        \(waypoint.x), \(waypoint.y), \(waypoint.z)
        \(waypoint.comment!)
        """
        
    }

}

extension ViewController: DataControllerDelegate {
    
    func dataControllerDidGetUpdates(waypoints: [WayPoint]) {
        
        plottedWayPoints.forEach { (point) in
            point.removeFromSuperview()
        }
        
        plottedWayPoints = []
        
        for waypoint in waypoints {
            
            guard let typeString = waypoint.type, let type = WayPointType(rawValue: typeString) else { fatalError("Unable to convert type")}
            
            plot(waypoint: waypoint, type: type)
            
            
            
            print(waypoint.x, waypoint.z)
        }
        
        
    }
}
