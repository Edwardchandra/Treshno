//
//  HistoryDetailViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 01/09/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    var image: UIImage?
    var destination: String?
    var wasteCollectorName: String?
    var dateTime: String?
    
    @IBOutlet weak var wasteCollectorNameLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var wasteImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(destination)
//        print(wasteCollectorName)
//        print(dateTime)

        wasteCollectorNameLabel.text = wasteCollectorName
        destinationLabel.text = destination
        dateTimeLabel.text = dateTime
        wasteImageView.image = image
        
        self.navigationItem.title = "Detil Riwayat Pesanan"
        
    }
    

}
