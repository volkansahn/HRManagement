//
//  AmirDayOffViewController.swift
//  IKYonetim
//
//  Created by Volkan on 20.07.2021.
//

import UIKit
import KeychainSwift

class AmirDayOffViewController: UIViewController {

    @IBOutlet weak var pastDayOffTableView: UITableView!
    @IBOutlet weak var pendingDayOffTableView: UITableView!
    var gecmisIzin = [GecmisIzin]()
    var bekleyenIzin = [BekleyenIzin]()
    let keychain = KeychainSwift()
    @IBOutlet weak var izinTalepButton: UIButton!
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    override func viewDidAppear(_ animated: Bool) {
        pastDayOffTableView.register(UINib(nibName: "DayOffTableViewCell", bundle: nil), forCellReuseIdentifier: "pastDayOff")
        pastDayOffTableView.dataSource = self
        pastDayOffTableView.delegate   = self

        pendingDayOffTableView.register(UINib(nibName: "ApproveDayOffTableViewCell", bundle: nil), forCellReuseIdentifier: "approveCell")
        pendingDayOffTableView.dataSource = self
        pendingDayOffTableView.delegate   = self
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.bekleyenIzin()
        client.gecmisIzin()
        izinTalepButton.isEnabled = true
        izinTalepButton.backgroundColor = .orange
        izinTalepButton.tintColor = .black
    
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


    @IBAction func requestDayoffPressed(_ sender: UIButton) {
        izinTalepButton.isEnabled = false
        izinTalepButton.backgroundColor = .gray
        izinTalepButton.tintColor = .white
        performSegue(withIdentifier: "toRequestDayOff", sender: self)
    }
    
}

extension AmirDayOffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == pastDayOffTableView{
            return gecmisIzin.count
        }else{
            return bekleyenIzin.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == pastDayOffTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pastDayOff") as! DayOffTableViewCell
            cell.formNo.text = String(gecmisIzin[indexPath.row].izin_id)
            cell.dayOffType.text = gecmisIzin[indexPath.row].izin_turu
            if (gecmisIzin[indexPath.row].durum == "onaylandı"){
                cell.status.text = "Onaylandi"
            }else{
                cell.status.text = "Onay Bekliyor"

            }
            return cell
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "approveCell") as! ApproveDayOffTableViewCell
            cell2.formNo.text = String(bekleyenIzin[indexPath.row].izin_id)
            cell2.type.text = String(bekleyenIzin[indexPath.row].izin_turu)
            cell2.adSoyadLabel.text = bekleyenIzin[indexPath.row].adi + " " + bekleyenIzin[indexPath.row].soyadi
            
            cell2.approveButtonPressed = {
                let userData = self.keychain.getData("calisan")
                self.calisan = self.decode(json: userData!, as: Calisan.self)!
                let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
                client.delegate = self
                client.izinOnayla(izin_id: self.bekleyenIzin[indexPath.row].izin_id)
            }
            
            return cell2
        }

    }

}

extension AmirDayOffViewController : HRClientDelegate{
    
    func gecmisIzin(_ response: GecmisIzinData) {
        DispatchQueue.main.async {
            if response.data.count > self.gecmisIzin.count{
                self.gecmisIzin.removeAll()
                self.gecmisIzin.append(contentsOf: response.data)
                self.pastDayOffTableView.reloadData()
            }
        }
    }
    
    func bekleyenIzin(_ response: BekleyenIzinData) {
        DispatchQueue.main.async {
            if response.is_success == false{
                self.bekleyenIzin.removeAll()
                self.pendingDayOffTableView.reloadData()
            }
            if response.data.count != self.bekleyenIzin.count{
                self.bekleyenIzin.removeAll()
                self.bekleyenIzin.append(contentsOf: response.data)
                self.pendingDayOffTableView.reloadData()
            }
        }
    }
    
    func success(_ response: SuccessData) {
        DispatchQueue.main.async {
            let userData = self.keychain.getData("calisan")
            self.calisan = self.decode(json: userData!, as: Calisan.self)!
            let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
            client.delegate = self
            client.bekleyenIzin()
        }
    }
    
    func failedWithError(error: Error) {
        DispatchQueue.main.async {
            self.bekleyenIzin.removeAll()
            self.pendingDayOffTableView.reloadData()

        }
    }

}
