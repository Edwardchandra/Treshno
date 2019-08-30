//
//  launchViewController.swift
//  Minimum
//
//  Created by Nanda Mochammad on 30/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class launchViewController: UIViewController {

    let defaults = UserDefaults.standard
    var emailUser = ""
    var pass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch loadFromUserDefaults() {
        case true:
            print("User Defaults true")
            self.performSegue(withIdentifier: "autoMain", sender: self)
            print("Go")
            break
        default:
            print("User Defaults false")
            self.performSegue(withIdentifier: "inputDataFirst", sender: self)
            print("Go")
            break
        }
    }
    
    func loadFromUserDefaults() -> Bool{
        var status = false
        if let email = defaults.string(forKey: "emailUser"), email != ""{
            self.emailUser = email
            status = true
        }
        if let password = defaults.string(forKey: "passUser"), password != ""{
            pass = password
            status = true
        }
        
        return status
    }


}
