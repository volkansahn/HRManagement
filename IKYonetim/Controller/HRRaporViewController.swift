//
//  HRRaporViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit

class HRRaporViewController: UIViewController {
    @IBOutlet weak var pastRaporTableView: UITableView!
    @IBOutlet weak var pendingRaporTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        pastRaporTableView.register(UINib(nibName: "CalisanRaporTableViewCell", bundle: nil), forCellReuseIdentifier: "calisanRaporCell")
        pastRaporTableView.delegate = self
        pastRaporTableView.dataSource = self

        pendingRaporTableView.register(UINib(nibName: "RaporApproveTableViewCell", bundle: nil), forCellReuseIdentifier: "raporOnayCell")
        pendingRaporTableView.dataSource = self
        pendingRaporTableView.delegate   = self

    }

}

extension HRRaporViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == pastRaporTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "calisanRaporCell") as! CalisanRaporTableViewCell
            cell.formNo.text = "1"
            cell.raporNedeni.text = "Soğuk Algınlığı"
            cell.status.text = "Onaylandı"
            return cell
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "raporOnayCell") as! RaporApproveTableViewCell
            cell2.formNo.text = "1"
            cell2.reason.text = "Baş Ağrısı"
            return cell2
        }

    }

}
