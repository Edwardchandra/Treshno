//
//  HistoryViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 31/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import CloudKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    let database = CKContainer.default().privateCloudDatabase
    var history = [CKRecord]()
    
    var selectedIndex = 0
    
    var emailValid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actIndicator.startAnimating()
        actIndicator.hidesWhenStopped = true

        self.navigationItem.title = "Riwayat Pesanan"
        historyTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        refreshPage()
        
        emailValid = UserDefaults.standard.string(forKey: "emailUser") ?? ""
        
        historyTableView.reloadData()
    }
    
    func refreshPage(){
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.9399943352, green: 0.3158932626, blue: 0.0476225093, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.historyTableView.refreshControl = refreshControl
        queryDatabase()
    }
    
    //MARK: Retrieve data from CloudKit
    @objc func queryDatabase(){
        
        let query = CKQuery(recordType: "History", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else {return}
            let sortedRecords = records.sorted(by: {$0.creationDate! > $1.creationDate!})
            
            self.history = sortedRecords
            DispatchQueue.main.async {
                self.historyTableView.refreshControl?.endRefreshing()
                self.historyTableView.reloadData()
                self.actIndicator.stopAnimating()

            }
            print("History = ", self.history)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberCount: Int = 0
        
        for i in 0..<history.count{
            let email = history[i].value(forKey: "email") as? String
            
            if email == emailValid{
                numberCount += 1
            }
        }
        
        return numberCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        
        
        for i in 0..<history.count{
            let email = history[i].value(forKey: "email") as? String
            
            if email == emailValid{
                let name = history[i].value(forKey: "name") as? String
                let destination = history[i].value(forKey: "destination") as? String
                let date = history[i].value(forKey: "date") as? String
                let time = history[i].value(forKey: "time") as? String
                
                let asset = history[i]["image"] as? CKAsset
                
                let imageData = NSData(contentsOf: (asset?.fileURL!)!)
                
                let image = UIImage(data: imageData! as Data)
                
                cell.historyWasteImageView.image = image
                //        cell.historyWasteImageView.layer.cornerRadius = cell.historyWasteImageView.frame.height/2
                
                cell.historyLocation.text = destination
                cell.historyWasteCollectorName.text = name
                cell.historyDateAndTime.text = date! + ", " + time!
            }
            
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyTableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndex = indexPath.row
        print("Selected Index: ", selectedIndex)
        
        performSegue(withIdentifier: "historyDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "historyDetailSegue"{
//            if let indexPath = historyTableView.indexPathForSelectedRow {
            guard let destViewController = segue.destination as? HistoryDetailViewController else {return}
            
            let asset = history[self.selectedIndex]["image"] as? CKAsset
        
            let imageData = NSData(contentsOf: (asset?.fileURL!)!)
        
                destViewController.image = UIImage(data: imageData! as Data)
        
                destViewController.destination = history[self.selectedIndex].value(forKey: "destination") as? String
                destViewController.wasteCollectorName = history[self.selectedIndex].value(forKey: "name") as? String
            destViewController.dateTime = history[self.selectedIndex].value(forKey: "time") as? String
//                        destViewController.dateTime = date! + ", " + time!
                
//            }
        }
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindOnboardSegue", sender: self)
        
        UserDefaults.standard.removeObject(forKey: "emailUser")
        
        UserDefaults.standard.removeObject(forKey: "passwordUser")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        
    }
}


