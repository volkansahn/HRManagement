//
//  CalisanDayOffViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit

class CalisanDayOffViewController: UIViewController {

    @IBOutlet weak var pastDayOffTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        pastDayOffTableView.register(UINib(nibName: "DayOffTableViewCell", bundle: nil), forCellReuseIdentifier: "pastDayOff")
        pastDayOffTableView.dataSource = self
        pastDayOffTableView.delegate   = self
    }
    @IBAction func dayOffRequestPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.toRequestDayOff, sender: self)
    }
}

extension CalisanDayOffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastDayOff") as! DayOffTableViewCell

        cell.formNo.text = "1"
        cell.dayOffType.text = "Mazeret"
        cell.status.text = "Onaylandı"

        return cell
    }

}
