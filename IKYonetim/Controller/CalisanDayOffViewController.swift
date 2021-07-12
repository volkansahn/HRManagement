//
//  CalisanDayOffViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class CalisanDayOffViewController: UIViewController {

    @IBOutlet weak var pastDayOffTableView: UITableView!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    var izin = [BekleyenIzin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pastDayOffTableView.register(UINib(nibName: "DayOffTableViewCell", bundle: nil), forCellReuseIdentifier: "pastDayOff")
        pastDayOffTableView.dataSource = self
        pastDayOffTableView.delegate   = self
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.bekleyenIzin()
    }
    
    @IBAction func dayOffRequestPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.toRequestDayOff, sender: self)
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

extension CalisanDayOffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return izin.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastDayOff") as! DayOffTableViewCell
        
        cell.formNo.text = String(izin[indexPath.row].id)
        cell.dayOffType.text = izin[indexPath.row].izinTuru
        if (izin[indexPath.row].izinIkOnay == true) && (izin[indexPath.row].izinYonOnay == true){
            cell.status.text = "Onaylandı"
        }else if (izin[indexPath.row].izinIkOnay == false) && (izin[indexPath.row].izinYonOnay == true){
            cell.status.text = "Yon.Onay Bekliyor"

        }else{
            cell.status.text = "iK Onay Bekliyor"
        }
            

        return cell
    }

}

extension CalisanDayOffViewController: HRClientDelegate{
    func bekleyenIzin(_ response: BekleyenIzinData) {
        DispatchQueue.main.async {
            self.izin.append(BekleyenIzin(id: response.data.id, izinTuru: response.data.izinTuru, izinBaslangic: response.data.izinBaslangic, izinBitis: response.data.izinBitis, izinYonOnay: response.data.izinYonOnay, izinIkOnay: response.data.izinIkOnay))
            self.pastDayOffTableView.reloadData()
        }
    }

}
