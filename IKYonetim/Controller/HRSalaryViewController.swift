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
        let userid = calisanIdTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanBilgi(calisan_id: userid)
    }
    
    @IBAction func calisanMaasGuncellePressed(_ sender: UIButton) {
        let newBazMaas = calisanGuncelMaasTextField.text!
        let newYanOdeme = calisanGuncelYanOdemeTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        if Int(newBazMaas) == nil || Int(newYanOdeme) == nil{
            let alert = UIAlertController(title: "Maas Hata", message: "Maas Bilgilerini Kontrol Edin !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else{
            client.maasGuncelle(calisan_id: calisanIdTextField.text!, guncel_maas: Int(newBazMaas)!, guncel_yan_odeme: Int(newYanOdeme)!)
        }
        
    }
    
}

extension HRSalaryViewController: HRClientDelegate{
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
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
}
