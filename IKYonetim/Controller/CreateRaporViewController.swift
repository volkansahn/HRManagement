//
//  CreateRaporViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class CreateRaporViewController: UIViewController {

    
    @IBOutlet weak var calisanIdTextField: UITextField!
    @IBOutlet weak var calisanAdSoyadLabel: UILabel!
    @IBOutlet weak var raporBaslangicDate: UIDatePicker!
    @IBOutlet weak var raporBitisDate: UIDatePicker!
    @IBOutlet weak var raporNedeniTextField: UITextField!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func calisanAraPressed(_ sender: UIButton) {
        let id = calisanIdTextField.text!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanBilgi(calisan_id: id)
    }
    
    @IBAction func raporOlusturPressed(_ sender: UIButton) {
        let raporNedeni = raporNedeniTextField.text!
        let dateFormatter = DateFormatter()
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.raporOlustur(raporNedeni: raporNedeni, raporBaslangic: dateFormatter.string(from: raporBaslangicDate.date), raporBitis: dateFormatter.string(from: raporBitisDate.date))
    }
    

}

extension CreateRaporViewController : HRClientDelegate{
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
            self.calisanAdSoyadLabel.text = response.data.adi  + " " + response.data.soyadi
        }
    }
}
