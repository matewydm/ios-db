//
//  CoreDataReadingsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataReadingsDetailViewController: BaseReadingsDetailViewController {
    // MARK: - Properties
    var readings = [Reading]()
    let coreDataService: AnyCoreDataService = CoreDataService.shared
    override var databaseService: AnyDatabaseService {
        return coreDataService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTable();
    }
    
    override func reloadTable() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Reading]
            self.readings = result
        } catch {
            print("Failed to load sensors")
        }
    }
    
}
// MARK: - UITableViewDataSource
extension CoreDataReadingsDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readings.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "\(readings[indexPath.row].sensor!.name!) - \(readings[indexPath.row].value), \(readings[indexPath.row].timestamp!)"
        
        return cell
    }
}
