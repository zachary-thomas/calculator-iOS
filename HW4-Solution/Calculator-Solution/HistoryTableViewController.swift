//
//  HistoryTableViewController.swift
//  Calculator iOS
//
//  Created by Zac on 10/30/19.
//  Copyright © 2019 Zachary Thomas and James Lund. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var entries: [Conversion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return entries;
        return 0;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // your code goes here
        return 0;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

       // your code goes here.

        return cell
    }

    
    
}
