//
//  BaseSensorsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

class BaseSensorsDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    var handlerId: Int = 0
    var databaseService: AnyDatabaseService! {
        assertionFailure("Overrite property with service configuring")
        return nil
    }
    // MARK: - PrivateProperties
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureService()
        configureTableView()
    }
    // MARK: - Private Configure Methods
    func configureService() {
        subscribe()
    }
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    // MARK: - Private Subscribe/Unsubscribe
    func subscribe() {
        handlerId = databaseService.addHandler { [weak self] (change) in
            guard let `self` = self else { return }
            switch change {
            case .generatingRecordsFinished(_):
                self.reloadTableView()
            case .experimentFinished(_): break
            //TODO: Reload TableView If Needed
            case .deleteAllFinished(_): 
                self.reloadTableView()
            case .logLine(_): break
            }
        }
    }
    func unsubscribe() {
        databaseService.removeHandler(handlerId)
    }
    
    func reloadTable() {
        assertionFailure("Override This Method")
    }
    
    func reloadTableView() {
        reloadTable();
        tableView.reloadData()
    }
    
    // MARK: - Actions
    // MARK: - Animation Methods
}
// MARK: - UITableViewDataSource
extension BaseSensorsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assertionFailure("Override This Method")
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assertionFailure("Override This Method")
        return UITableViewCell()
    }
}
// MARK: - UITableViewDelegate
extension BaseSensorsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
