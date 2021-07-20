//
//  HRSalaryViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class HRSalaryViewController: UIViewController {

    @IBOutlet weak var calisanBazMaasLabel: UILabel!
    @IBOutlet weak var calisanYanOdemeLabel: UILabel!
    @IBOutlet weak var calisanToplamMaasLabel: UILabel!
    @IBOutlet weak var calisanIdTextField: UITextField!
    @IBOutlet weak var calisanGuncelMaasTextField: UITextField!
    @IBOutlet weak var calisanGuncelYanOdemeTextField: UITextField!
    @IBOutlet weak var calisanAdSoyadLabel: UILabel!
    @IBOutlet weak var kullaniciAraButton: UIButton!
    @IBOutlet weak var maasGuncelleButton: UIButton!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        let loginClient = HRHttpClient(kullanici_id: calisan.id, sifre: "sifre")
        loginClient.delegate = self
        loginClient.login()
        calisanBazMaasLabel.text = String(calisan.bazMaas!)
        calisanYanOdemeLabel.text = String(calisan.yanOdeme!)
        calisanToplamMaasLabel.text = String(calisan.bazMaas! + calisan.yanOdeme!)
        kullaniciAraButton.isEnabled = true
        kullaniciAraButton.backgroundColor = .orange
        kullaniciAraButton.tintColor = .white
        maasGuncelleButton.isEnabled = true
        maasGuncelleButton.backgroundColor = .orange
        maasGuncelleButton.tintColor = .white
       
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
    
    
    @IBAction func calisanAraPressed(_ sender: UIButton) {
        kullaniciAraButton.isEnabled = false
        kullaniciAraButton.backgroundColor = .gray
        kullaniciAraButton.tintColor = .white

        let userid = calisanIdTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanBilgi(calisan_id: userid)
    }
    
    @IBAction func calisanMaasGuncellePressed(_ sender: UIButton) {
        maasGuncelleButton.isEnabled = false
        maasGuncelleButton.backgroundColor = .gray
        maasGuncelleButton.tintColor = .black
        let newBazMaas = calisanGuncelMaasTextField.text!
        let newYanOdeme = calisanGuncelYanOdemeTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        if Int(newBazMaas) == nil || Int(newYanOdeme) == nil{
            let alert = UIAlertController(title: "Maas Hata", message: "Maas Bilgilerini Kontrol Edin !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else{
            client.maasGuncelle(calisan_id: calisanIdTextField.text!, guncel_maas: Int(newBazMaas)!, guncel_yan_odeme: Int(newYanOdeme)!)
        }
        
    }
    func okPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HRSalaryViewController: HRClientDelegate{
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
            self.kullaniciAraButton.isEnabled = true
            self.kullaniciAraButton.backgroundColor = .orange
            self.kullaniciAraButton.tintColor = .white
            let isim = response.data.adi
            let soyisim = response.data.soyadi
            let calisanAdSoyad = isim + " " + soyisim
            self.calisanAdSoyadLabel.text = calisanAdSoyad
        }
    }
    func isLogin(_ response: LoginData) {
        DispatchQueue.main.async {
            self.calisan = Calisan(id: response.data.id!, isim: response.data.isim!, sifre: "", soyisim: response.data.soyisim!, rol: response.data.rol!, amir_id: "", token: "", bazMaas: response.data.bazMaas, yanOdeme: response.data.yanOdeme)
        }
    }
    func failedWithError(error: Error) {
        DispatchQueue.main.async {
            self.maasGuncelleButton.isEnabled = true
            self.maasGuncelleButton.backgroundColor = .orange
            self.maasGuncelleButton.tintColor = .white
            let alert = UIAlertController(title: "Maas Hata", message: "Maas Bilgilerini Kontrol Edin !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }
    }
    func calisanAraError(error: Error) {
        let alert = UIAlertController(title: "Calisan Hata", message: "Calisan Bulunamadı !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    func success(_ response: SuccessData) {
      
        DispatchQueue.main.async {
            self.maasGuncelleButton.isEnabled = true
            self.maasGuncelleButton.backgroundColor = .orange
            self.maasGuncelleButton.tintColor = .white
            let alert = UIAlertController(title: "Maas Guncelleme", message: "Maas Guncelleme Yapildi !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {action in self.okPressed()}))
            self.present(alert, animated: true)
        }
    }
}
