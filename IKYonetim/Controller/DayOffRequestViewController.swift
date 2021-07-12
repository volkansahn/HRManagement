//
//  DayOffRequestViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class DayOffRequestViewController: UIViewController {

    @IBOutlet weak var izinBaslangicDate: UIDatePicker!
    @IBOutlet weak var izinBitisDate: UIDatePicker!
    @IBOutlet weak var izinTipiSecim: UISegmentedControl!
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

    @IBAction func izinTalepPressed(_ sender: UIButton) {
        let izinTuru = izinTipiSecim.selectedSegmentIndex
        let dateFormatter = DateFormatter()
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.izinTalebi(izin_turu: String(izinTuru), izinBaslangic: dateFormatter.string(from: izinBaslangicDate.date), izinBitis: dateFormatter.string(from: izinBitisDate.date))
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
}

extension DayOffRequestViewController: HRClientDelegate{


}
