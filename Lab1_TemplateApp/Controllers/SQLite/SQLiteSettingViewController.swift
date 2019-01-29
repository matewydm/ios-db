//
//  SQLiteSettingViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

class SQLiteSettingViewController: BaseSettingViewController {
    // MARK: - Properties
    let sqliteService: AnySQLiteService = SQLiteService.shared
    override var databaseService: AnyDatabaseService {
        return sqliteService
    }
}
