//
//  CoreDataService.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol AnyCoreDataService: AnyDatabaseService {
    // TODO: - Add extra methods if needed
}

class CoreDataService {
    // MARK: - Static Properties
    static let shared: CoreDataService = CoreDataService()
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

extension CoreDataService: AnyCoreDataService {
    // MARK: - AnyDatabaseService -
    // MARK: - Generate Methods
    func generate(recordsNumber: Int) {
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine(#function))
        notifyObservers(change: .logLine("Amount: \(recordsNumber)"))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
        var sensors : [Sensor]
        do {
            sensors = try context.fetch(request) as! [Sensor]
        } catch {
            print("Error while getting sensors")
            return;
        }
        for i in 1...recordsNumber {
            let sensor = sensors[Int(arc4random_uniform(UInt32(sensors.count)))]
            let reading = Reading(context: context)
            let value = Float(arc4random())/Float(UInt32.max) + Float(arc4random_uniform(100))
            let randomTimestamp = Int(arc4random_uniform(31536000)) + 1514764800
            let randomDate = NSDate(timeIntervalSince1970: Double(exactly: randomTimestamp)!)
            reading.setValue(randomDate, forKey: "timestamp")
            reading.setValue(value, forKey: "value")
            reading.sensor = sensor
            sensor.addToReading(reading)
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        notifyObservers(change: .generatingRecordsFinished(0))
    }
    // MARK: - Experiments Methods
    func makeExperiment(recordsNumber: Int) {
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine(#function))
        
        deleteAllRecords()
        
        let startTime = NSDate()
        
        generate(recordsNumber: recordsNumber)
        
        let min = self.selectEdgeReading(true)
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("min value \(min.value) "))
        let max = self.selectEdgeReading(false)
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("max value \(max.value) "))
        let average = self.selectAverageReadingValue()
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("average \(average) "))
        let countOfSensor = self.selectCountOfSensor()
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("sensorCounts \(countOfSensor) "))
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("experiment with \(recordsNumber) passed in \(measuredTime) "))
    }
    
    func selectCountOfSensor() -> [Dictionary<String, Any>] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let valueKey = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "count:", arguments: [valueKey])
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["sensor.name"]
        request.propertiesToFetch = ["sensor.name", countDesc]
        request.resultType = .dictionaryResultType
        do {
            return try context.fetch(request) as! [Dictionary<String, Any>]
        } catch {
            print("Error while requesting average reading")
        }
        return []
    }
    
    func selectAverageReadingValue() -> Float {
        var average : Float = 0.0;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let valueKey = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "average:", arguments: [valueKey])
        let avgDesc = NSExpressionDescription()
        avgDesc.expression = expression
        avgDesc.name = "avg"
        avgDesc.expressionResultType = .floatAttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = [avgDesc]
        request.resultType = .dictionaryResultType
        do {
            let tmp = try context.fetch(request) as! [Dictionary<String, NSNumber>]
            average = tmp.first!["avg"]?.floatValue ?? 0
        } catch {
            print("Error while requesting average reading")
        }
        return average;
    }
    
    func selectEdgeReading(_ isAscending: Bool) -> Reading {
        var reading: Reading = Reading()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor.init(key: "value", ascending: isAscending)]
        do {
            reading = try context.fetch(request).first as! Reading
        } catch {
            print("Error while requesting reading")
        }
        return reading
    }
    
    // MARK: - Delete Methods
    func deleteAllRecords() {
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine(#function))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print("Failed deletion of readings")
        }
        notifyObservers(change: .deleteAllFinished(0))
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
