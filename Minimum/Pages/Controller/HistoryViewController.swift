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
    
    let database = CKContainer.default().privateCloudDatabase
    var history = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshPage()
        queryDatabase()
    }
    
    func refreshPage(){
        
        let refreshControl = UIRefreshControl()
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
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        let name = history[indexPath.row].value(forKey: "name") as! String
        let destination = history[indexPath.row].value(forKey: "destination") as! String
        let date = history[indexPath.row].value(forKey: "date") as! String
        let time = history[indexPath.row].value(forKey: "time") as! String
        
        let asset = history[indexPath.row]["image"] as? CKAsset
        
        let imageData = NSData(contentsOf: (asset?.fileURL!)!)
        
        let image = UIImage(data: imageData! as Data)
        cell.historyWasteImageView.image = image
        
        
        cell.historyLocation.text = destination
        cell.historyWasteCollectorName.text = name
        cell.historyDateAndTime.text = date + " at " + time
        
        return cell
    }
    
}


