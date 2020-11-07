//
//  GenerateDeclaration.swift
//  Coronavoider
//
//  Created by Octavian Custura on 07/11/2020.
//

import Foundation
import TPPDF
import UIKit

class MyDate {
    var day: Int, month: Int, year: Int
    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
}
class User {
    var firstName: String
    var surname: String
    var address: String
    var currentAddress: String?
    var dateOfBirth: Date?
    var placeOfBirth: String
    
    init(name: String, surname: String, address: String, currentAddress: String? = nil, dateOfBirth: DateComponents, placeOfBirth: String) {
        self.firstName = name
        self.surname = surname
        self.address = address
        self.currentAddress = currentAddress
        let userCalendar = Calendar.current
        self.dateOfBirth = userCalendar.date(from: dateOfBirth)
        self.placeOfBirth = placeOfBirth
    }
}


class Declaration {
    var user: User
    var currentDate:Date
    var duties: [Duty]
    init(user: User, currentDate: Date, duties: [Duty]) {
        self.user = user
        self.currentDate = currentDate
        self.duties = duties
        self.duties = self.duties.sorted { $0.number < $1.number }
        noElement = PDFImage(image: noImage)
        yesElement = PDFImage(image: yesImage)
        self.createDocument()
    }
    var url: URL = URL(fileURLWithPath: "")
    let yesImage = UIImage(named: "YesIdea")!
    let noImage = UIImage(named: "NoIdea")!
    let yesElement: PDFImage
    let noElement: PDFImage
    
    private func addFirst(yes: Bool, document: PDFDocument, work: Work = Work()) {
        var text = "În interes profesional. Menționez că îmi desfășor activitatea profesională la instituția/societatea/organizația "
        if yes {
            document.add(image: yesElement)
            text += work.society
            document.add(text: text)
            text = "cu sediul în " + work.location
            document.add(text: text)
            text = "și cu punct/e de lucru la următoarele adrese: "
            if work.workPoint1 == nil {
                document.add(text: "\n\n")
            } else {
                text += work.workPoint1!
                document.add(text: text)
                if work.workPoint2 == nil {
                    document.add(text: "\n")
                } else {
                    document.add(text: work.workPoint2!)
                }
            }
        } else {
            document.add(image: noElement)
            document.add(text: "În interes profesional. Menționez că îmi desfășor activitatea profesională la instituția/societatea/organizația \n" )
            document.add(text: "cu sediul în \n")
            document.add(text: "și cu punct/e de lucru la următoarele adrese: \n\n")
        }
    }
    private var arr: [String] = [
        "Asistență medicală care nu poate fi amânată și nici realizată de la distanță",
        "Achiziționarea de medicamente",
        "Îngrijirea/însoțirea copilului și/sau asistența persoanelor vârstnice, bolnave sau cu dizabilități",
        "Deces al unui membru al familiei"
    ]
    private func addOther(value: Int, yes: Bool, document: PDFDocument) {
        if yes {
            document.add(image: yesElement)
        } else {
            document.add(image: noElement)
        }
        document.add(text: arr[value - 2])
    }
    public func createDocument() {
        let document = PDFDocument(format: .a4)
        
        let image = UIImage(named: "ms")!
        let imageElement = PDFImage(image: image)
        document.add(.headerRight, image: imageElement)
        document.add(.contentCenter, text: "DECLARATIE PE PROPRIE RASPUNDERE")
        document.add(text: "\n")
        document.set(font: UIFont.systemFont(ofSize: 14.0))
        document.add(text: "Subsemnatul/a: " + user.surname + " " + user.firstName)
        document.add(text: "domiciliat/ă în: " + user.address)
        var text = "cu reședința în fapt în: "
        if user.currentAddress == nil {
            text += user.address
        } else {
            text += user.currentAddress! as String
        }
        document.add(text: text)
        text = "născut/ă în data de: "
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        text += formatter.string(from: user.dateOfBirth!)
        text += " în localitatea " + user.placeOfBirth
        document.add(text:  text)
        
        document.add(text: "declar pe proprie răspundere, cunoscând prevederile articolului 326 din Codul Penal privind falsul în declarații, că mă deplasez în afara locuinței, în intervalul orar 23.00 – 05.00, din următorul/următoarele motive:\n")
        

        var cnt: Int = 1
        while (!self.duties.isEmpty) {
            let elem = self.duties.removeFirst()
            for i in cnt..<elem.number {
                if i == 1 {
                    addFirst(yes: false, document: document)
                } else {
                    addOther(value: i, yes: false, document: document)
                }
                cnt -= -1
            }
            if elem.number == 1 {
                addFirst(yes: true, document: document, work: elem as! Work)
            } else {
                addOther(value: elem.number, yes: true, document: document)
            }
            cnt -= -1
        }
        document.add(space: 25)
        text = "Data "
        text += formatter.string(from: currentDate)
        document.add(.contentLeft, text: text)
        text = "Semnătura................."
        document.add(.contentRight, text: text)
        
        
        document.set(.footerCenter, font: UIFont.systemFont(ofSize: 8))

        text = "**Declarația pe propria răspundere poate fi stocată și prezentată pentru control pe dispozitive electronice mobile, cu condiția ca pe documentul prezentat să existe semnătura olografă a persoanei care folosește Declarația și data pentru care este valabilă declarația."
        document.add(.footerCenter, text: text)
        text = "*Declarația pe propria răspundere poate fi scrisă de mână, cu condiția preluării tuturor elementelor prezentate mai sus"
        document.add(.footerCenter, text: text)
        let generator = PDFGenerator(document: document)
        url = try! generator.generateURL(filename: "DeclaratieProprieRaspundere.pdf")
    }
}
