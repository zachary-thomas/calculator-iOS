//
//  HistoryTableViewController.swift
//  Calculator iOS
//
//  Created by Zac on 10/30/19.
//  Copyright © 2019 Zachary Thomas and James Lund. All rights reserved.
//

import UIKit

protocol HistoryTableViewControllerDelegate {
    func selectEntry(entry: Conversion)
}


class HistoryTableViewController: UITableViewController {
    
    var entries: [Conversion] = []
    var historyDelegate: HistoryTableViewControllerDelegate?
    
    //@IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.entries = entries
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return entries;
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // your code goes here
        return entries.count;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

       // your code goes here.
        let entry: Conversion = self.entries[indexPath.row] //? before []
        cell.textLabel?.text = "\(entry.fromVal) \(entry.fromUnits) = \(entry.toVal) \(entry.toUnits)"
        cell.detailTextLabel?.text = entry.timestamp.short //"Date: CHANGE ME" //String (entry.timestamp)
        if let defaultImage = UIImage(named: "Entries"){
            cell.imageView?.image = defaultImage
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // use the historyDelegate to report back entry selected to the calculator scene
        if let del = self.historyDelegate {
            let conv = entries[indexPath.row]
            del.selectEntry(entry: conv)
        }
        
        // this pops back to the main calculator
        _ = self.navigationController?.popViewController(animated: true)
    }

    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    struct Formatter {
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    
    var short: String {
        return Formatter.short.string(from: self)
    }
}
