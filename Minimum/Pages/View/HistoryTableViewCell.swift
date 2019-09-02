//
//  HistoryTableViewCell.swift
//  Minimum
//
//  Created by Edward Chandra on 31/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historyWasteImageView: UIImageView!
    
    @IBOutlet weak var historyLocation: UILabel!
    @IBOutlet weak var historyWasteCollectorName: UILabel!
    @IBOutlet weak var historyDateAndTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
