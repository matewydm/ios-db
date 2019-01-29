//
//  RealmService.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import RealmSwift

protocol AnyRealmService: AnyDatabaseService {
    func getAllSensors() -> [AnySensorModel]
    func getAllRecords() -> [AnyRecordModel]
    // TODO: - Add extra methods if needed
}

class RealmService {
    // MARK: - Static Properties
    static let shared: RealmService = RealmService()
    // MARK: - Properties
    var startTime: Date?
    // MARK: - Private Properties
    fileprivate var observingHandlers: [Int: DatabaseServiceHandler] = [:]
    // MARK: - Init
    private init() {
        // TODO: Configure Service If You want
    }
    deinit {
        observingHandlers.removeAll()
    }
    // MARK: - Private Help/Cofigure/Init etc. Methods
    // TODO: - Work There...
}

extension RealmService: AnyRealmService {
    // MARK: - AnySQLiteService -
    func getAllSensors() -> [AnySensorModel] {
        return [] // TODO: - Implement
    }
    func getAllRecords() -> [AnyRecordModel] {
        return [] // TODO: - Implement
    }
    // MARK: - AnyDatabaseService -
    // MARK: - Generate Methods
    func generate(recordsNumber: Int) {
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine(#function))
        
        let realm = try! Realm()
        let sensors = Array(realm.objects(SensorRealm.self))
        
        for i in 1...recordsNumber {
            let sensor = sensors[Int(arc4random_uniform(UInt32(sensors.count)))]
            let reading = ReadingRealm();
            let value = Float(arc4random())/Float(UInt32.max) + Float(arc4random_uniform(100))
            let randomTimestamp = Int(arc4random_uniform(31536000)) + 1514764800
            let randomDate = NSDate(timeIntervalSince1970: Double(exactly: randomTimestamp)!)
            reading.timestampRecord = randomDate
            reading.valueRecord = value
            try! realm.write {
                reading.sensorModel = sensor
                realm.add(reading)
                sensor.readings.append(reading)
                realm.add(sensor, update: true)
            }
        }
        notifyObservers(change: .generatingRecordsFinished(0))
    }
    // MARK: - Experiments Methods
    func makeExperiment(recordsNumber: Int) {
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine(#function))
    
        deleteAllRecords()
        
        let startTime = NSDate()
        
        generate(recordsNumber: recordsNumber)
        
        let min = self.selectEdgeReading(true)
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine("min value \(min.valueRecord) "))
        let max = self.selectEdgeReading(false)
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine("max value \(max.valueRecord) "))
        let average = self.selectAverageReadingValue()
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine("average \(average) "))
        let countOfSensor = self.selectCountOfSensor()
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine("sensorCounts \(countOfSensor) "))
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine("experiment with \(recordsNumber) passed in \(measuredTime) "))
        
    }
    
    func selectCountOfSensor() -> [Dictionary<String, Any>] {
        return []
    }
    
    func selectAverageReadingValue() -> Float {
        let realm = try! Realm()
        return realm.objects(ReadingRealm.self).average(ofProperty: "valueRecord")!
    }
    
    func selectEdgeReading(_ isAscending: Bool) -> ReadingRealm {
        let realm = try! Realm()
        return realm.objects(ReadingRealm.self)
            .sorted(byKeyPath: "valueRecord", ascending: isAscending)
            .first!
    }
    
    // MARK: - Delete Methods
    func deleteAllRecords() {
        notifyObservers(change: .logLine("Realm"))
        notifyObservers(change: .logLine(#function))
        let realm = try! Realm()
        let readings = realm.objects(ReadingRealm.self)
        try! realm.write {
            realm.delete(readings)
        }
    }
    
    // MARK: - Handler Methods
    func addHandler(_ completion: @escaping DatabaseServiceHandler) -> Int {
        var maxId = observingHandlers.keys.max() ?? 0
        maxId += 1
        observingHandlers[maxId] = completion
        return maxId
    }
    func removeHandler(_ handlerId: Int) {
        observingHandlers.removeValue(forKey: handlerId)
    }
    private func notifyObservers(change: DatabaseServiceChange) {
        observingHandlers.forEach { (handler) in
            handler.value(change)
        }
    }
}
