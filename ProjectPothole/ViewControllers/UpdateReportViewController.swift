import Foundation
import FirebaseFirestore
import MapKit

class UpdateReportViewController: UIViewController{
    
    @IBOutlet weak var textViewRereport: UITextView!
    var severitySelected: Double!
    
    @IBOutlet weak var reratingLabel: UILabel!
    
    var existingPothole: Pothole!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //saves existing pothole
        existingPothole = ReportLocationViewController.GlobalVariable.existingPothole

        
        let keyboardDown = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
           view.addGestureRecognizer(keyboardDown)
    }
    
    @IBAction func button1PressedRereport(_ sender: Any) {
        severitySelected = 1
        reratingLabel.text = "1"
    }
    
    @IBAction func button2PressedRereport(_ sender: Any) {
        severitySelected = 2
        reratingLabel.text = "2"
    }
    
    @IBAction func button3PressedRereport(_ sender: Any) {
        severitySelected = 3
        reratingLabel.text = "3"
    }

    @IBAction func button4PressedRereport(_ sender: Any) {
        severitySelected = 4
        reratingLabel.text = "4"
    }

    @IBAction func button5PressedRereport(_ sender: Any) {
        severitySelected = 5
        reratingLabel.text = "5"
    }

    // change within here to calculate the new average and severity level
    // add to database
    @IBAction func submiteButtonPressedRereport(_ sender: Any) {
        if (reratingLabel.text == "" || reratingLabel.text == "You must select a number")
        {
            reratingLabel.text = "You must select a number"
        }
        else
        {
            existingPothole.setSeverity(severity: severitySelected)
            existingPothole.encounters+=1
            
            if let locationSave = ReportLocationViewController.GlobalVariable.saveLocation, let severitySave = existingPothole.severity as? Double, let encountersSave = existingPothole.encounters as? Double, let commentSave = textViewRereport.text as Any? {
                db.collection(K.FStore.collectionName).document(existingPothole.id).setData([
                    K.FStore.locationField: locationSave,
                    K.FStore.severityField: severitySave,
                    K.FStore.encountersField: encountersSave,
                    K.FStore.commentField: FieldValue.arrayUnion([commentSave]),
                ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        
                        DispatchQueue.main.async {
                             self.textViewRereport.text = ""
                        }
                    }
                }
            }
            UIView.animate(withDuration: 0.1)
            {
                self.performSegue(withIdentifier: "endReport", sender: self)
            }
        }
        
        

    }
}
