//
//  HistoryTableViewController.swift
//  Calculator iOS
//
//  Created by Zac and James on 10/30/19.
//  Copyright © 2019 Zachary Thomas and James Lund. All rights reserved.
//

import UIKit

protocol HistoryTableViewControllerDelegate {
    func selectEntry(entry: Conversion)
}


class HistoryTableViewController: UITableViewController {
    
    var entries: [Conversion] = [Conversion(fromVal: 1, toVal: 1760, mode: .Length, fromUnits: LengthUnit.Miles.rawValue, toUnits:
        LengthUnit.Yards.rawValue, timestamp: Date.distantPast),
                                 Conversion(fromVal: 1, toVal: 4, mode: .Volume, fromUnits: VolumeUnit.Gallons.rawValue, toUnits:
                                    VolumeUnit.Quarts.rawValue, timestamp: Date.distantFuture)]
    
    var historyDelegate: HistoryTableViewControllerDelegate?
    
    var tableViewData: [(sectionHeader: String, entries: [Conversion])]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func sortIntoSections(entries: [Conversion]) {
        
        var tmpEntries : Dictionary<String,[Conversion]> = [:]
        var tmpData: [(sectionHeader: String, entries: [Conversion])] = []
        
        // partition into sections
        for entry in entries {
            let shortDate = entry.timestamp.short
            if var bucket = tmpEntries[shortDate] {
                bucket.append(entry)
                tmpEntries[shortDate] = bucket
            } else {
                tmpEntries[shortDate] = [entry]
            }
        }
        
        // breakout into our preferred array format
        let keys = tmpEntries.keys
        for key in keys {
            if let val = tmpEntries[key] {
                tmpData.append((sectionHeader: key, entries: val))
            }
        }
        
        // sort by increasing date.
        tmpData.sort { (v1, v2) -> Bool in
            if v1.sectionHeader < v2.sectionHeader {
                return true
            } else {
                return false
            }
        }
        
        self.tableViewData = tmpData
    }

    
    //@IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortIntoSections(entries: self.entries)
        
    }
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        //return entries;
//        return 1;
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // your code goes here
//        return entries.count;
//    }


//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//
//       // your code goes here.
//        let entry: Conversion = self.entries[indexPath.row] //? before []
//        cell.textLabel?.text = "\(entry.fromVal) \(entry.fromUnits) = \(entry.toVal) \(entry.toUnits)"
//        cell.detailTextLabel?.text = entry.timestamp.short //"Date: CHANGE ME" //String (entry.timestamp)
//        if let defaultImage = UIImage(named: "Entries"){
//            cell.imageView?.image = defaultImage
//        }
//
//        return cell
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FancyCell", for: indexPath) as! HistoryTableViewCell
        if let entry = self.tableViewData?[indexPath.section].entries[indexPath.row] {
            cell.conversionLabel.text = "\(entry.fromVal) \(entry.fromUnits) = \(entry.toVal) \(entry.toUnits)"
            cell.timestampLabel.text = "\(entry.timestamp.description)"
            cell.thumbnail.image = UIImage(imageLiteralResourceName: entry.mode == .Volume ? "volume" : "length")
        }
        return cell
    }
    

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) ->
        String? {
            return self.tableViewData?[section].sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
        CGFloat {
            return 80.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection
        section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = BACKGROUND_COLOR
        header.contentView.backgroundColor = FOREGROUND_COLOR
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = BACKGROUND_COLOR
        header.contentView.backgroundColor = FOREGROUND_COLOR
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // use the historyDelegate to report back entry selected to the calculator scene
        if let del = self.historyDelegate {
            if let conv = self.tableViewData?[indexPath.section].entries[indexPath.row] {
                del.selectEntry(entry: conv)
            }
        }
        
        // this pops to the calculator
        _ = self.navigationController?.popViewController(animated: true)
    }

    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // use the historyDelegate to report back entry selected to the calculator scene
//        if let del = self.historyDelegate {
//            let conv = entries[indexPath.row]
//            del.selectEntry(entry: conv)
//        }
//
//        // this pops back to the main calculator
//        _ = self.navigationController?.popViewController(animated: true)
//    }

  
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let data = self.tableViewData {
            return data.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sectionInfo = self.tableViewData?[section] {
            return sectionInfo.entries.count
        } else {
            return 0
        }
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
