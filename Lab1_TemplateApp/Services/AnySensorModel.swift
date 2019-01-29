//
//  AnySensorModel.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - AnySensorModel
protocol AnySensorModel {
    /// Properties
    var nameSensor: String { get }
    var descriptionSensor: String { get }

}

class SensorRealm: Object, AnySensorModel {
    @objc dynamic var nameSensor: String = ""
    @objc dynamic var descriptionSensor: String = ""
    let readings = List<ReadingRealm>()
    
    override static func primaryKey() -> String? {
        return "nameSensor"
    }
}
