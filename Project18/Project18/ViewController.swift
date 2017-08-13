//
//  ViewController.swift
//  Project18
//
//  Created by Glenn R. Fisher on 8/12/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // simple debugging with print statements
        // print(1, 2, 3, 4, 5, separator: ", ", terminator: "\n")
        
        // debugging with assertions (assertions are removed from a released app)
        // assert(1 == 1, "Math failure")
        // assert(1 == 2, "Math failure")
        
        // debugging with breakpoint
        // note: can set condition on breakpoints (e.g. `i % 10 == 0`)
        // note: can add an exception breakpoint
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
        
        // debugging views
        // note: can enable Debug -> View Debugging -> Show View Frames to show view boundaries
        // note: can use Debug -> View Debugging -> Capture View Hierarchy to show a 3d representation
    }
}

