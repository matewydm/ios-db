//
//  CoreDataSensorsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataSensorsDetailViewController: BaseSensorsDetailViewController {
    // MARK: - Properties
    var sensors = [Sensor]()
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Sensor]
            self.sensors = result
        } catch {
            print("Failed to load sensors")
        }
    }
}
// MARK: - UITableViewDataSource
extension CoreDataSensorsDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = sensors[indexPath.row].name! + ", " + sensors[indexPath.row].desc!
        
        return cell
    }
    
}
