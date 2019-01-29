//
//  RealmSensorsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RealmSensorsDetailViewController: BaseSensorsDetailViewController {
    // MARK: - Properties
    var sensors = [SensorRealm]()
    
    let realmService: AnyRealmService = RealmService.shared
    override var databaseService: AnyDatabaseService {
        return realmService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTable();
    }
    
    override func reloadTable() {
        let realm = try! Realm()
        sensors = Array(realm.objects(SensorRealm.self))
    }
}
// MARK: - UITableViewDataSource
extension RealmSensorsDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Implement Method
        return sensors.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - Implement Method
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = sensors[indexPath.row].nameSensor + ", " + sensors[indexPath.row].descriptionSensor
        
        return cell
    }
}
