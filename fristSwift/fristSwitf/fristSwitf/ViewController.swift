//
//  ViewController.swift
//  fristSwitf
//
//  Created by Victor Ho on 2019/8/31.
//  Copyright © 2019年 iONCreate Studio. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBAction func sayButtonClicked(_ sender: Any) {
        var name = nameField.stringValue
        if name.isEmpty {
            name = "World"
        }
        let greeting = "Hello \(name)!"
        helloLabel.stringValue = greeting
    }
    @IBOutlet weak var helloLabel: NSTextField!
    @IBOutlet weak var nameField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

