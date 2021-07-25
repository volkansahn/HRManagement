//
//  HRRaporViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class HRRaporViewController: UIViewController {
    @IBOutlet weak var pastRaporTableView: UITableView!
    @IBOutlet weak var pendingRaporTableView: UITableView!
    var bekleyenRapor = [BekleyenRapor]()

    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    var rapor = [GecmisRapor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pastRaporTableView.register(UINib(nibName: "CalisanRaporTableViewCell", bundle: nil), forCellReuseIdentifier: "calisanRaporCell")
        pastRaporTableView.delegate = self
        pastRaporTableView.dataSource = self

        pendingRaporTableView.register(UINib(nibName: "RaporApproveTableViewCell", bundle: nil), forCellReuseIdentifier: "raporOnayCell")
        pendingRaporTableView.dataSource = self
        pendingRaporTableView.delegate   = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.gecmisRapor()
        client.bekleyenRapor()
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

extension HRRaporViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rapor.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == pastRaporTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "calisanRaporCell") as! CalisanRaporTableViewCell
            cell.formNo.text = String(rapor[indexPath.row].rapor_id!)
            cell.raporNedeni.text = rapor[indexPath.row].nedeni
            if (rapor[indexPath.row].nedeni == "onaylandı"){
                cell.status.text = "Onaylandi"
            }else{
                cell.status.text = "Onay Bekliyor"

            }
            return cell
            
        } else {
           
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "raporOnayCell") as! RaporApproveTableViewCell
            cell2.formNo.text = String(bekleyenRapor[indexPath.row].izin_id)
            cell2.reason.text = String(bekleyenRapor[indexPath.row].nedeni)
            cell2.adSoyadLabel.text = bekleyenRapor[indexPath.row].adi + " " + bekleyenRapor[indexPath.row].soyadi
            
            cell2.approveButtonPressed = {
                let userData = self.keychain.getData("calisan")
                self.calisan = self.decode(json: userData!, as: Calisan.self)!
                let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
                client.delegate = self
                client.raporOnayla(rapor_id: self.bekleyenRapor[indexPath.row].izin_id)
            }
            return cell2
        }

    }

}

extension HRRaporViewController: HRClientDelegate{
    func gecmisRapor(_ response: GecmisRaporData) {
        DispatchQueue.main.async {
            self.rapor.append(contentsOf: response.data)
            self.pastRaporTableView.reloadData()
        }
    }
    
    func bekleyenRapor(_ response: BekleyenRaporData) {
        DispatchQueue.main.async {
            if response.is_success == false{
                self.bekleyenRapor.removeAll()
                self.pendingRaporTableView.reloadData()
            }
            if response.data.count != self.bekleyenRapor.count{
                self.bekleyenRapor.removeAll()
                self.bekleyenRapor.append(contentsOf: response.data)
                self.pendingRaporTableView.reloadData()
            }
        }
    }
    
    func success(_ response: SuccessData) {
        DispatchQueue.main.async {
            let userData = self.keychain.getData("calisan")
            self.calisan = self.decode(json: userData!, as: Calisan.self)!
            let client = HRHttpClient(kullanici_id: self.calisan.id, authToken: self.calisan.token)
            client.delegate = self
            client.bekleyenRapor()
        }
    }
    
    func failedWithError(error: Error) {
        DispatchQueue.main.async {
            self.bekleyenRapor.removeAll()
            self.pendingRaporTableView.reloadData()

        }
    }
}
