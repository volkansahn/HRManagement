//
//  ApproveDayOffTableViewCell.swift
//  IKYonetim
//
//  Created by Volkan on 14.06.2021.
//

import UIKit

class ApproveDayOffTableViewCell: UITableViewCell {
    var approveButtonPressed : (() -> ()) = {}
    @IBOutlet weak var formNo: UILabel!
    @IBOutlet weak var adSoyadLabel: UILabel!
    @IBOutlet weak var type: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func approvePressed(_ sender: UIButton) {
        approveButtonPressed()
    }
    
}
