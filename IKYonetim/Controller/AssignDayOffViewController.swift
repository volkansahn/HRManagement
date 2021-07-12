//
//  AssignDayOffViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class AssignDayOffViewController: UIViewController {

    @IBOutlet weak var calisanidTextField: UITextField!
    
    @IBOutlet weak var calisanAdiLabel: UILabel!
    @IBOutlet weak var calisanMazeretTextField: UITextField!
    @IBOutlet weak var calisanYillikTextField: UITextField!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func calisanAraPressed(_ sender: UIButton) {
        let id = calisanidTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanBilgi(calisan_id: id)
    }
    
    @IBAction func izinTanimlaPressed(_ sender: UIButton) {
        let id = calisanidTextField.text!
        let guncelMazeret = calisanMazeretTextField.text!
        let guncelYillik = calisanYillikTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.izinGuncelle(calisan_id: id, mazeret_izni: Int(guncelMazeret)!, yillik_izni: Int(guncelYillik)!)
    }
    
}

extension AssignDayOffViewController : HRClientDelegate{
    
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
            self.calisanAdiLabel.text = response.data.isim  + " " + response.data.soyisim
        }
    }
    
}
