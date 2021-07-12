//
//  DayOffRequestViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit

class DayOffRequestViewController: UIViewController {

    @IBOutlet weak var izinBaslangicDate: UIDatePicker!
    @IBOutlet weak var izinBitisDate: UIDatePicker!
    @IBOutlet weak var izinTipiSecim: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func izinTalepPressed(_ sender: UIButton) {
    }
    

}
