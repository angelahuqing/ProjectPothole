//
//  Pothole.swift
//  ProjectPothole
//

import Foundation
import Firebase
import FirebaseFirestore

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
