//
//  DayOffTableViewCell.swift
//  IKYonetim
//
//  Created by Volkan on 14.06.2021.
//

import UIKit

class DayOffTableViewCell: UITableViewCell {
    @IBOutlet weak var formNo: UILabel!
    @IBOutlet weak var dayOffType: UILabel!
    @IBOutlet weak var status: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
