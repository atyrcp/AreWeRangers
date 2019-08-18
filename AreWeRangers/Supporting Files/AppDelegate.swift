//
//  AppDelegate.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/16.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rangersCellDataArray = [CellData]()
    var elasticCellDataArray = [CellData]()
    var dynamoCellDataArray = [CellData]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let context = persistentContainer.viewContext
        deleteAll()
        for cellData in rangersCellDataArray {
            let savedRangers = SavedRangers(entity: SavedRangers.entity(), insertInto: context)
            savedRangers.setProperty(with: cellData)
            self.saveContext()
        }
        for cellData in elasticCellDataArray {
            let savedElastic = SavedElastic(entity: SavedElastic.entity(), insertInto: context)
            savedElastic.setProperty(with: cellData)
            self.saveContext()
        }
        for cellData in rangersCellDataArray {
            let savedDynamo = SavedDynamo(entity: SavedDynamo.entity(), insertInto: context)
            savedDynamo.setProperty(with: cellData)
            self.saveContext()
        }
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
//        let context = persistentContainer.viewContext
//        let savedRangers = SavedRangers(entity: SavedRangers.entity(), insertInto: context)
//        let savedElastic = SavedElastic(entity: SavedElastic.entity(), insertInto: context)
//        let savedDynamo = SavedDynamo(entity: SavedDynamo.entity(), insertInto: context)
//
//        for cellData in rangersCellDataArray {
//            savedRangers.setProperty(with: cellData)
//            savedRangersData = []
//            savedRangersData.append(savedRangers)
//        }
//        for cellData in elasticCellDataArray {
//            savedElastic.setProperty(with: cellData)
//            savedElasticData = []
//            savedElasticData.append(savedElastic)
//        }
//        for cellData in rangersCellDataArray {
//            savedDynamo.setProperty(with: cellData)
//            savedDynamoData = []
//            savedDynamoData.append(savedDynamo)
//        }
//        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AreWeRangers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = SavedRangers.fetchRequest()
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest1)
        } catch {
            let error  = error as Error
            print(error)
        }
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = SavedElastic.fetchRequest()
        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest2)
        } catch {
            let error  = error as Error
            print(error)
        }
        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = SavedDynamo.fetchRequest()
        let deleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest3)
        } catch {
            let error  = error as Error
            print(error)
        }

        
    }

}

