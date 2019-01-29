//
//  RealmSettingViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

class RealmSettingViewController: BaseSettingViewController {
    // MARK: - Properties
    let realmService: AnyRealmService = RealmService.shared
    override var databaseService: AnyDatabaseService {
        return realmService
    }
}
