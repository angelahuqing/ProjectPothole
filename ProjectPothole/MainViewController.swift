//
//  MainViewController.swift
//  ProjectPothole
//
//  Created by Natalia Luzuriaga on 1/18/20.
//  Copyright © 2020 ucsbteam. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import FirebaseFirestore
import CoreLocation

class MainViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let db = Firestore.firestore()
    
    let locationManager = CLLocationManager()
    
    var potholes: [Pothole] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: false)
        
        loadPotholes()
        
        //test
        //        let london = MKPointAnnotation()
        //        london.title = "London"
        //        london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        //        mapView.addAnnotation(london)
        
    }
    
    
    func loadPotholes(){
        
        db.collection(K.FStore.collectionName)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.potholes = []

                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                }
                else {
                    //reads data from firestore
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            //creates new pothole and adds to array
                            if let locationSave = data[K.FStore.locationField] as? GeoPoint, let severitySave = data[K.FStore.severityField] as? Double, let commentsSave = data[K.FStore.commentField] as? [String]  {
                                let newPothole = Pothole(location: locationSave, severity: severitySave, comments: commentsSave)
                                self.potholes.append(newPothole)
                            }
                        }
                    }
                    
                }
                //adds pin where pothole is at
                for pothole in self.potholes {
                    let pHole = MKPointAnnotation()
                    pHole.title = "Pothole"
                    pHole.coordinate = CLLocationCoordinate2D(latitude: pothole.location.latitude, longitude: pothole.location.longitude)
                    self.mapView.addAnnotation(pHole)
                }
        }
    }
    
    
    //adds a point
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}
