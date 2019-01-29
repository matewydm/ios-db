//
//  AppDelegate.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        print(Bundle.main.bundlePath)
        initSensors()
        return true
    }

    func initSensors() {
        initCoreSensors(20);
        initRealmSensors(20);
    }
    
    func initRealmSensors(_ recordsNumber: Int){
        for i in 1...recordsNumber {
            let sensor = SensorRealm();
            sensor.nameSensor = "S\(i)"
            sensor.descriptionSensor = "Sensor number \(i)"
            let realm = try! Realm()
            let sensors = realm.objects(SensorRealm.self).filter("nameSensor = '\(sensor.nameSensor)'")
            if (!sensors.isEmpty) {
                print("Sensor with name \(sensor.nameSensor) already exists")
                continue
            } else {
                try! realm.write {
                    realm.add(sensor)
                }
            }
            
        }
    }
    
    func initCoreSensors(_ recordsNumber: Int){
        let context = self.persistentContainer.viewContext
        for i in 1...recordsNumber {
            var dbSensor : [Sensor] = []
            let sensorName = "S\(i)"
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
            request.predicate = NSPredicate(format: "name == %@", sensorName)
            do {
                dbSensor = try context.fetch(request) as! [Sensor]
            } catch {
                print("Failed getting sensor with name \(sensorName)")
            }
            if (!dbSensor.isEmpty) {
                print("Sensor with name \(sensorName) already exists")
                continue
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: context)
                let sensor = NSManagedObject(entity: entity!, insertInto: context)
                sensor.setValue(sensorName, forKey: "name")
                sensor.setValue("Sensor number \(i)", forKey: "desc")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Lab1_TemplateApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

