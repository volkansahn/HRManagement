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
        client.maasGuncelle(calisan_id: calisan.id, guncel_maas: Int(newBazMaas)!, guncel_yan_odeme: Int(newYanOdeme)!)
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
}
