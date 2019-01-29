//
//  RealmReadingsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RealmReadingsDetailViewController: BaseReadingsDetailViewController {
    // MARK: - Properties
    var readings = [ReadingRealm]()
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
        readings = Array(realm.objects(ReadingRealm.self))
    }
}
// MARK: - UITableViewDataSource
extension RealmReadingsDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Implement Method
        return readings.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - Implement Method
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
        //\(readings[indexPath.row].sensorModel?.nameSensor)
        cell.textLabel?.text = "\(readings[indexPath.row].sensorModel!.nameSensor) - \(readings[indexPath.row].valueRecord), \(readings[indexPath.row].timestampRecord)"
        
        return cell
    }
}
