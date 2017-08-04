//
//  ViewController.swift
//  Project6b
//
//  Created by Glenn R. Fisher on 8/3/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .red
        label1.text = "THESE"
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .cyan
        label2.text = "ARE"
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .yellow
        label3.text = "SOME"
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .green
        label4.text = "AWESOME"
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .orange
        label5.text = "LABELS"
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        let views = [
            "label1": label1,
            "label2": label2,
            "label3": label3,
            "label4": label4,
            "label5": label5
        ]
        
        // demonstrate VFL constraints
        addVFLConstraints(views: views)
        
        // demonstrate anchor constraints
        // addAnchorConstraints(views: views)
    }
    
    func addVFLConstraints(views: [String: UILabel]) {
        for label in views.keys {
            let format = "H:|[\(label)]|"
            let constraints = NSLayoutConstraint.constraints(
                withVisualFormat: format,
                options: [],
                metrics: nil,
                views: views
            )
            view.addConstraints(constraints)
        }
        
        let format = "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|"
        let metrics = ["labelHeight": 88]
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: format,
            options: [],
            metrics: metrics,
            views: views
        )
        view.addConstraints(constraints)
    }
    
    func addAnchorConstraints(views: [String: UILabel]) {
        var previous: UILabel!
        
        for label in views.values {
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            if previous != nil {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            }
            
            previous = label
        }
    }
}

