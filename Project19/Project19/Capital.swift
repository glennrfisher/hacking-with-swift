//
//  Capital.swift
//  Project19
//
//  Created by Glenn R. Fisher on 8/13/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
