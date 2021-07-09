//
//  CalisanRaporViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit

class CalisanRaporViewController: UIViewController {

    @IBOutlet weak var pastRaporTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        pastRaporTableView.register(UINib(nibName: "CalisanRaporTableViewCell", bundle: nil), forCellReuseIdentifier: "calisanRaporCell")
        pastRaporTableView.dataSource = self
        pastRaporTableView.delegate   = self
    }
}

extension CalisanRaporViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calisanRaporCell") as! CalisanRaporTableViewCell

        cell.formNo.text = "1"
        cell.raporNedeni.text = "Boğaz Ağrısı"
        cell.status.text = "Onaylandı"

        return cell
    }

}
