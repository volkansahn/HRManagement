//
//  CalisanSalaryViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class CalisanSalaryViewController: UIViewController {

    @IBOutlet weak var calisanBazMaasLabel: UILabel!
    @IBOutlet weak var calisanYanOdemeLabe: UILabel!
    @IBOutlet weak var calisanToplamMaas: UILabel!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        calisanBazMaasLabel.text = String(calisan.bazMaas!)
        calisanYanOdemeLabe.text = String(calisan.yanOdeme!)
        calisanToplamMaas.text = String(calisan.bazMaas! + calisan.yanOdeme!)
       
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

extension CalisanSalaryViewController: HRClientDelegate{
    
}
