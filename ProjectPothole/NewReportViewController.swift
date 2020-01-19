//
//  ReportViewController.swift
//  ProjectPothole
//
//  Created by Natalia Luzuriaga on 1/18/20.
//  Copyright © 2020 ucsbteam. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit

class NewReportViewController: UIViewController{
    
    @IBOutlet weak var textView: UITextView!
    var severitySelected: Double!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardDown = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
           view.addGestureRecognizer(keyboardDown)
    }
    
    @IBAction func button1Pressed(_ sender: Any) {
        severitySelected = 1
        ratingLabel.text = "1"
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        severitySelected = 2
        ratingLabel.text = "2"
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        severitySelected = 3
        ratingLabel.text = "3"
    }

    @IBAction func button4Pressed(_ sender: Any) {
        severitySelected = 4
        ratingLabel.text = "4"
    }

    @IBAction func button5Pressed(_ sender: Any) {
        severitySelected = 5
        ratingLabel.text = "5"
    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        
        if let locationSave = ReportLocationViewController.GlobalVariable.saveLocation, let severitySave = severitySelected, let commentSave = textView.text as Any? {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.locationField: locationSave,
                K.FStore.severityField: severitySave,
                K.FStore.commentField: FieldValue.arrayUnion([commentSave]),
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                         self.textView.text = ""
                    }
                }
            }
        }
    }
}
