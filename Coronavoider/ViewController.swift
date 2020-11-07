//
//  ViewController.swift
//  Coronavoider
//
//  Created by Octavian Custura on 07/11/2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var societyTextField: UITextField!
    @IBOutlet weak var workPlace1TextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var workPlace2TextField: UITextField!
    @IBOutlet weak var workCheck: UISwitch!
    @IBOutlet weak var medicalCheck: UISwitch!
    @IBOutlet weak var medicineCheck: UISwitch!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var caretakingCheck: UISwitch!
    @IBOutlet weak var middleNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var deceasedCheck: UISwitch!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var currentAddressField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var placeOfBirthField: UITextField!

    
    @IBAction func generateButton(_ sender: Any) {
        print("Intru in functie")
        var name = firstNameField.text! as String
        if middleNameField.text != nil {
            name += " " + middleNameField.text!
        }
        let lastName = lastNameField.text!
        let address = addressField.text!
        let currentAddress = currentAddressField.text
        let dateString = dateOfBirthField.text! as String
        let date = dateString.components(separatedBy: ".").map{element in
            Int(element)
        }
        let dateOfBirth = DateComponents(year: date[2], month: date[1], day: date[0])
        let placeOfBirth = placeOfBirthField.text!
        var duties = [Duty]()
        
        if (workCheck.isOn) {
            let society = societyTextField.text!
            let location = locationTextField.text!
            let workPlace1 = workPlace1TextField.text
            let workPlace2 = workPlace2TextField.text
            duties.append(Work(society: society, location: location, workPoint1: workPlace1, workPoint2: workPlace2))
        }
        if (medicalCheck.isOn) {
            duties.append(MedicalAssistance())
        }
        if (medicineCheck.isOn) {
            duties.append(MedsBuy())
        }
        if (caretakingCheck.isOn) {
            duties.append(Caretaking())
        }
        if (deceasedCheck.isOn) {
            duties.append(DeceasedPerson())
        }
        let user = User(name: name, surname: lastName, address: address, currentAddress: currentAddress, dateOfBirth: dateOfBirth, placeOfBirth: placeOfBirth)
        let declaration = Declaration(user: user, currentDate: Date(), duties: duties)
        let url = [declaration.url]
        let ac = UIActivityViewController(activityItems: url, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Declaration(user: User(name: "Octavian", surname: "Custura", address: "Preot Vladeanu 17", currentAddress: "Preot Vladeanu 13", dateOfBirth: DateComponents(year: 2000, month: 10, day: 28), placeOfBirth: "Bacau"), currentDate: Date(), duties: [DeceasedPerson(), Work(society: "McDonald's", location: "Bacau", workPoint1: "TicTac", workPoint2: "Arena Mall Bacau"), MedsBuy()])
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard)))
    }
    


}

