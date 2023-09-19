//
//  StationInfoTableViewCell.swift
//  UbikeStationInfo
//
//  Created by 吳玹銘 on 2023/9/19.
//

import UIKit

class StationInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
