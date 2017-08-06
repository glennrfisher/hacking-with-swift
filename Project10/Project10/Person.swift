//
//  Person.swift
//  Project10
//
//  Created by Glenn R. Fisher on 8/5/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
