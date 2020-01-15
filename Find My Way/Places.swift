//
//  Places.swift
//  Find My Way
//
//  Created by MacStudent on 2020-01-14.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D
    
    init( coordinate: CLLocationCoordinate2D) {
       
        self.coordinate = coordinate
    }
    
   
}

