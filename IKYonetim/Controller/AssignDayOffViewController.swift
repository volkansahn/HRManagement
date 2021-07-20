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
    @IBOutlet weak var calisanAraButton: UIButton!
    @IBOutlet weak var izinTanimlaButton: UIButton!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calisanAraButton.isEnabled = true
        calisanAraButton.backgroundColor = .orange
        calisanAraButton.tintColor = .white
        izinTanimlaButton.isEnabled = true
        izinTanimlaButton.backgroundColor = .orange
        izinTanimlaButton.tintColor = .white
    }

    @IBAction func calisanAraPressed(_ sender: UIButton) {
        calisanAraButton.isEnabled = false
        calisanAraButton.backgroundColor = .gray
        calisanAraButton.tintColor = .white
        let id = calisanidTextField.text!
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!

        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanBilgi(calisan_id: id)
    }
    
    @IBAction func izinTanimlaPressed(_ sender: UIButton) {
        izinTanimlaButton.isEnabled = false
        izinTanimlaButton.backgroundColor = .gray
        izinTanimlaButton.tintColor = .white
        let id = calisanidTextField.text!
        let guncelMazeret = calisanMazeretTextField.text!
        let guncelYillik = calisanYillikTextField.text!
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!

        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.izinGuncelle(id: id, mazeret_izni: Int(guncelMazeret)!, yillik_izni: Int(guncelYillik)!)
    }
    
    func decode<T: Decodable>(json: Data, as clazz: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(T.self, from: json)
            
            return data
        } catch {
            print("An error occurred while parsing JSON")
        }
        
        return nil
    }
    
    func okPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
}



extension AssignDayOffViewController : HRClientDelegate{
    func success(_ response: SuccessData) {
        DispatchQueue.main.async {
            self.izinTanimlaButton.isEnabled = true
            self.izinTanimlaButton.backgroundColor = .orange
            self.izinTanimlaButton.tintColor = .white
            let alert = UIAlertController(title: "İzin Tanimlama", message: "İzin Tanimlama Yapildi !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {action in self.okPressed()}))
            self.present(alert, animated: true)
        }
    }
    func failedWithError(error: Error) {
        DispatchQueue.main.async {
            self.izinTanimlaButton.isEnabled = true
            self.izinTanimlaButton.backgroundColor = .orange
            self.izinTanimlaButton.tintColor = .white
            let alert = UIAlertController(title: "Hata", message: "İzin Tanimlama Hatasi !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
            self.calisanAraButton.isEnabled = true
            self.calisanAraButton.backgroundColor = .orange
            self.calisanAraButton.tintColor = .white
            self.calisanAdiLabel.text = response.data.adi  + " " + response.data.soyadi
        }
    }
    
}
