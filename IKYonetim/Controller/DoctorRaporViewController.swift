//
//  DoctorRaporViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class DoctorRaporViewController: UIViewController {

    @IBOutlet weak var pastRaporTableView: UITableView!
    @IBOutlet weak var pendingRaporTableView: UITableView!
    @IBOutlet weak var raporOlusturButton: UIButton!
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

    @IBAction func createRaporPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toCreateRapor", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.gecmisRapor()
       
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

extension DoctorRaporViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rapor.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calisanRaporCell") as! CalisanRaporTableViewCell
        cell.formNo.text = String(rapor[indexPath.row].rapor_id!)
        cell.raporNedeni.text = rapor[indexPath.row].nedeni
        if (rapor[indexPath.row].nedeni == "onaylandı"){
            cell.status.text = "Onaylandi"
        }else{
            cell.status.text = "Onay Bekliyor"

        }
        return cell
    }

}


extension DoctorRaporViewController: HRClientDelegate{
    func gecmisRapor(_ response: GecmisRaporData) {
        DispatchQueue.main.async {
            self.rapor.append(contentsOf: response.data)
            self.pastRaporTableView.reloadData()
        }
    }
}
