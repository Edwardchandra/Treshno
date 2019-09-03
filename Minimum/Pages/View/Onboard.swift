//
//  Onboard.swift
//  Minimum
//
//  Created by Edward Chandra on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class Onboard: UIView {
    
    @IBOutlet weak var onboardSliderView: UIView!
    
    @IBOutlet weak var onboardImageView: UIImageView!
    @IBOutlet weak var onboardLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func customizeElement(){
        onboardSliderView.layer.cornerRadius = 11
    }

}
