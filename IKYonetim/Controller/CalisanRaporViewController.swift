//
//  CalisanRaporViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class CalisanRaporViewController: UIViewController {

    @IBOutlet weak var pastRaporTableView: UITableView!
    let keychain = KeychainSwift()
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    var rapor = [GecmisRapor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pastRaporTableView.register(UINib(nibName: "CalisanRaporTableViewCell", bundle: nil), forCellReuseIdentifier: "calisanRaporCell")
        pastRaporTableView.dataSource = self
        pastRaporTableView.delegate   = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
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

extension CalisanRaporViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rapor.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calisanRaporCell") as! CalisanRaporTableViewCell

        cell.formNo.text = String(rapor[indexPath.row].id!)
        cell.raporNedeni.text = rapor[indexPath.row].raporNedeni
        if rapor[indexPath.row].onay == true{
            cell.status.text = "Onaylandı"

        }else{
            cell.status.text = "iK Onay Bekliyor"
        }
        return cell
    }

}

extension CalisanRaporViewController: HRClientDelegate{
    func gecmisRapor(_ response: GecmisRaporData) {
        DispatchQueue.main.async {
            self.rapor.append(GecmisRapor(id: response.data.id, raporNedeni: response.data.raporNedeni, raporBaslangic: response.data.raporBaslangic, raporBitis: response.data.raporBitis, onay: response.data.onay))
            self.pastRaporTableView.reloadData()
        }
    }
}
