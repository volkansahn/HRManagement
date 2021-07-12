//
//  AdminManageUserViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class AdminManageUserViewController: UIViewController {

    @IBOutlet weak var calisanidTextField: UITextField!
    @IBOutlet weak var calisanSifreTextField: UITextField!
    @IBOutlet weak var calisanAdiTextField: UITextField!
    @IBOutlet weak var calisanSoyadiTextField: UITextField!
    @IBOutlet weak var calisanRolTextField: UITextField!
    @IBOutlet weak var amirAdiTextField: UITextField!
    @IBOutlet weak var amirSoyadiTextField: UITextField!
    
    @IBOutlet weak var calisanSicilAraTextField: UITextField!
    
    @IBOutlet weak var calisanidResponseLabel: UILabel!
    @IBOutlet weak var calisanAdiResponseLabel: UILabel!
    @IBOutlet weak var calisanSoyadiResponseLabel: UILabel!
    @IBOutlet weak var calisanRoluResponseLabel: UILabel!
    @IBOutlet weak var calisanAmirResponseLabel: UILabel!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
       
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
    
    //Create
    @IBAction func kisiOlusturPressed(_ sender: UIButton) {
        let id = calisanidTextField.text!
        let sifre = calisanSifreTextField.text!
        let adi = calisanAdiTextField.text!
        let soyadi = calisanSoyadiTextField.text!
        let rol = calisanRolTextField.text!
        let amirAdi = amirAdiTextField.text!
        let amirSoyAdi = amirSoyadiTextField.text!
        let amir = amirAdi + " " + amirSoyAdi
        let newCalisan = Calisan(id: id, isim: adi, sifre: sifre, soyisim: soyadi, rol: rol, amir_id: amir, token: " ", bazMaas: 1, yanOdeme: 1)
        
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.calisanOlustur(calisan: newCalisan)
    }
    //Update
    @IBAction func calisanAraPressed(_ sender: UIButton) {
        let id = calisanSicilAraTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanBilgi(calisan_id: id)
    }
    @IBAction func calisanSicilEditPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sicil Guncelle", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Yeni Sicili Girin"
        })
        
        alert.addAction(UIAlertAction(title: "Guncelle", style: .default, handler: { action in
            
            if let yeniSicil = alert.textFields?.first?.text {
                let guncelCalisan = Calisan(id: yeniSicil, isim: self.calisanAdiTextField.text!, sifre: self.calisanSifreTextField.text!, soyisim: self.calisanSoyadiTextField.text!, rol: self.calisanRolTextField.text!, amir_id: self.amirAdiTextField.text!, token: " ", bazMaas: 1, yanOdeme: 1)
                let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
                client.delegate = self
                client.calisanGuncelle(calisan_id: self.calisanSicilAraTextField.text!, calisan: guncelCalisan)
    
            }
        }))
        
        self.present(alert, animated: true)
    }
    @IBAction func calisanAdiEditPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Ad Guncelle", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Yeni Sicili Girin"
        })
        
        alert.addAction(UIAlertAction(title: "Guncelle", style: .default, handler: { action in
            
            if let yeniAd = alert.textFields?.first?.text {
                let guncelCalisan = Calisan(id: self.calisanidTextField.text!, isim: yeniAd, sifre: self.calisanSifreTextField.text!, soyisim: self.calisanSoyadiTextField.text!, rol: self.calisanRolTextField.text!, amir_id: self.amirAdiTextField.text!, token: " ", bazMaas: 1, yanOdeme: 1)
                let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
                client.delegate = self
                client.calisanGuncelle(calisan_id: self.calisanSicilAraTextField.text!, calisan: guncelCalisan)
    
            }
        }))
        
        self.present(alert, animated: true)
    }
    @IBAction func calisanSoyadiEditPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Soyad Guncelle", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Yeni Soyad Girin"
        })
        
        alert.addAction(UIAlertAction(title: "Guncelle", style: .default, handler: { action in
            
            if let yeniSoyad = alert.textFields?.first?.text {
                let guncelCalisan = Calisan(id: self.calisanidTextField.text!, isim: self.calisanAdiTextField.text!, sifre: self.calisanSifreTextField.text!, soyisim: yeniSoyad, rol: self.calisanRolTextField.text!, amir_id: self.amirAdiTextField.text!, token: " ", bazMaas: 1, yanOdeme: 1)
                let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
                client.delegate = self
                client.calisanGuncelle(calisan_id: self.calisanSicilAraTextField.text!, calisan: guncelCalisan)
    
            }
        }))
        
        self.present(alert, animated: true)
    }
    @IBAction func calisanRoluEditPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Rol Guncelle", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Yeni Rol Girin"
        })
        
        alert.addAction(UIAlertAction(title: "Guncelle", style: .default, handler: { action in
            
            if let yeniRol = alert.textFields?.first?.text {
                let guncelCalisan = Calisan(id: self.calisanidTextField.text!, isim: self.calisanAdiTextField.text!, sifre: self.calisanSifreTextField.text!, soyisim: self.calisanSoyadiTextField.text!, rol: yeniRol, amir_id: self.amirAdiTextField.text!, token: " ", bazMaas: 1, yanOdeme: 1)
                let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
                client.delegate = self
                client.calisanGuncelle(calisan_id: self.calisanSicilAraTextField.text!, calisan: guncelCalisan)
    
            }
        }))
        
        self.present(alert, animated: true)
    }
    @IBAction func calisanAmirEditPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Amir Guncelle", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Yeni Amir Girin"
        })
        
        alert.addAction(UIAlertAction(title: "Guncelle", style: .default, handler: { action in
            
            if let yeniAmir = alert.textFields?.first?.text {
                let guncelCalisan = Calisan(id: self.calisanidTextField.text!, isim: self.calisanAdiTextField.text!, sifre: self.calisanSifreTextField.text!, soyisim: self.calisanSoyadiTextField.text!, rol: self.calisanRolTextField.text!, amir_id: yeniAmir, token: " ", bazMaas: 1, yanOdeme: 1)
                let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
                client.delegate = self
                client.calisanGuncelle(calisan_id: self.calisanSicilAraTextField.text!, calisan: guncelCalisan)
    
            }
        }))
        
        self.present(alert, animated: true)
    }
    //Delete
    @IBAction func kullaniciSilPressed(_ sender: UIButton) {
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanSil(calisan_id: calisanidTextField.text!)
    }
    
    
}

extension AdminManageUserViewController: HRClientDelegate{
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
            self.calisanidResponseLabel.text = response.data.kullanici_id
            self.calisanAdiResponseLabel.text = response.data.adi
            self.calisanSoyadiResponseLabel.text = response.data.soyadi
            self.calisanRoluResponseLabel.text = response.data.rol_id
            self.calisanAmirResponseLabel.text = ""
        }
    }
}
