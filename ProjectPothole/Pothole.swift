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
    
    var id: String
    var location: GeoPoint
    var severity: Double
    var encounters: Double
    var comments: [String]
    
    init(id: String, location: GeoPoint, severity: Double, encounters:Double, comments:[String]){
        self.id = id
        self.location = location
        self.severity = severity
        self.encounters = encounters
        self.comments = comments
    }
    
    public func setSeverity(severity: Double){
        if (severity > 0){
            self.severity = (self.severity + severity) / 2
        }
    }
}
