//
//  Person.swift
//  Project10
//
//  Created by Glenn R. Fisher on 8/5/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else { return nil }
        guard let image = aDecoder.decodeObject(forKey: "image") as? String else { return nil }
        self.name = name
        self.image = image
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
