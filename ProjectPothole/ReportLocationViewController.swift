//
//  ReportLocationViewController.swift
//  ProjectPothole
//
//  Created by Natalia Luzuriaga on 1/18/20.
//  Copyright © 2020 ucsbteam. All rights reserved.
//

import Foundation
import MapKit
import FirebaseFirestore

class ReportLocationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // cone flag pic to replace marker
    let coneFlag = UIImage(named: "cone_flag")
    
    var decoder: CLGeocoder = CLGeocoder()
    var location: CLLocationCoordinate2D!
    
    var locationName: String?
    
    struct GlobalVariable{
        static var saveLocation: GeoPoint!
        static var existingPothole: Pothole!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creates annotation
        mapView.delegate = self
        mapView.showsUserLocation = true
        let annotation = MKPointAnnotation()
        if !mapView.annotations.contains(where: { $0 is MKPointAnnotation }) {
            mapView.addAnnotation(annotation)
        }
        if let location = location {
            mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)), animated: false)
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        var hasExistingPothole: Bool = false
        
        let range = 0.0001
        
        GlobalVariable.saveLocation = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        
        let lat = GlobalVariable.saveLocation.latitude
        
        let lon = GlobalVariable.saveLocation.longitude
        
        for pothole in MainViewController.GlobalVariableMain.potholes{
            
            if(abs(pothole.location.latitude - lat) <= range) && (abs(pothole.location.longitude - lon) <= range){
                hasExistingPothole = true
                GlobalVariable.existingPothole = pothole
                break;
            }
            else{
                //is this necessary lol
                hasExistingPothole = false
            }
        }
      
        if (hasExistingPothole == true)
        {
            UIView.animate(withDuration: 0.1)
            {
                self.performSegue(withIdentifier: "alreadyReported", sender: self)
            }
        }//segue into corresponding screen based on hasExistingPothole variable
        
    }
}

extension ReportLocationViewController {
    func mapViewMoved(_ mapView: MKMapView) {
        if let annotation = mapView.annotations.first(where: { ($0 is MKPointAnnotation) }) as? MKPointAnnotation {
            UIView.animate(withDuration: 0.1) {
                annotation.coordinate = mapView.centerCoordinate
            }
        }
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        location = mapView.centerCoordinate
        locationName = nil
        mapViewMoved(mapView)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        location = mapView.centerCoordinate
        decoder.cancelGeocode()
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        decoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            guard error == nil else {
                self.locationName = nil
                print(error!)
                return
            }
            guard let placemarks = placemarks else {
                self.locationName = nil
                print("placemarks nil")
                return
            }
            if placemarks.count == 0 {
                self.locationName = nil
            }
            self.locationName = placemarks[0].name
        }
        mapViewMoved(mapView)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        location = mapView.centerCoordinate
        locationName = nil
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var dequeueView: MKMarkerAnnotationView
        if let dqView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? MKMarkerAnnotationView {
            dequeueView = dqView
        } else {
            dequeueView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        }
        dequeueView.displayPriority = .required
        return dequeueView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if location == nil {
            mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)), animated: false)
        }
    }
}
