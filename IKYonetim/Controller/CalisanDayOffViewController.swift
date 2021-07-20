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
    var izin = [GecmisIzin]()
    @IBOutlet weak var izinTalepButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        pastDayOffTableView.register(UINib(nibName: "DayOffTableViewCell", bundle: nil), forCellReuseIdentifier: "pastDayOff")
        pastDayOffTableView.dataSource = self
        pastDayOffTableView.delegate   = self
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        izinTalepButton.isEnabled = true
        izinTalepButton.backgroundColor = .orange
        izinTalepButton.tintColor = .black
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.bekleyenIzin()
        client.gecmisIzin()
    }
    
    @IBAction func dayOffRequestPressed(_ sender: UIButton) {
        izinTalepButton.isEnabled = false
        izinTalepButton.backgroundColor = .gray
        izinTalepButton.tintColor = .white
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
        cell.formNo.text = String(izin[indexPath.row].izin_id)
        cell.dayOffType.text = izin[indexPath.row].izin_turu
        if (izin[indexPath.row].durum == "onaylandı"){
            cell.status.text = "Onaylandi"
        }else{
            cell.status.text = "Onay Bekliyor"

        }

        return cell
    }

}

extension CalisanDayOffViewController: HRClientDelegate{
    func gecmisIzin(_ response: GecmisIzinData) {
        DispatchQueue.main.async {
            if response.data.count > self.izin.count{
                self.izin.removeAll()
                self.izin.append(contentsOf: response.data)
                self.pastDayOffTableView.reloadData()
            }
        }
    }

}
