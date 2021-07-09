//
//  CalisanRaporTableViewCell.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit

class CalisanRaporTableViewCell: UITableViewCell {

    @IBOutlet weak var formNo: UILabel!
    @IBOutlet weak var raporNedeni: UILabel!
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
