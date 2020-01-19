//
//  Pothole.swift
//  ProjectPothole
//
//  Created by Natalia Luzuriaga on 1/18/20.
//  Copyright © 2020 ucsbteam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

//TODO: equatable

class Pothole: Identifiable {
    var location: GeoPoint
    var severity: Double
    var comments: [String]
    
    init(location: GeoPoint, severity: Double, comments:[String]){
        self.location = location
        self.severity = severity
        self.comments = comments
    }
    
}
