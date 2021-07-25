//
//  RaporApproveTableViewCell.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit

class RaporApproveTableViewCell: UITableViewCell {
    @IBOutlet weak var formNo: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var adSoyadLabel: UILabel!
    var approveButtonPressed : (() -> ()) = {}

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
