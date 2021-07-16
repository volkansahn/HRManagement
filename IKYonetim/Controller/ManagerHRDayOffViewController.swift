//
//  ManagerHRDayOffViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class ManagerHRDayOffViewController: UIViewController {

    @IBOutlet weak var pastDayOffTableView: UITableView!

    @IBOutlet weak var pendingDayOffTableView: UITableView!
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
    }

    @IBAction func assignDayOff(_ sender: UIButton) {
        performSegue(withIdentifier: "toAssignDayOff", sender: self)
    }
    @IBAction func requestDayoffPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRequestDayOff", sender: self)
    }
    
}

extension ManagerHRDayOffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == pastDayOffTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pastDayOff") as! DayOffTableViewCell
            cell.formNo.text = "1"
            cell.dayOffType.text = "Mazeret"
            cell.status.text = "Onaylandı"
            return cell
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "approveCell") as! ApproveDayOffTableViewCell
            cell2.formNo.text = "1"
            cell2.type.text = "Yıllık İzin"
            return cell2
        }

    }

}
