//
//  ViewController.swift
//  XaddressLoader
//
//  Created by Paul Von Schrottky on 10/15/16.
//  Copyright © 2016 Xaddress. All rights reserved.
//

import UIKit
import SwiftCSV
import CoreData

class ViewController: UIViewController {
    
    var countries: CSV!
    var states: CSV!
    var nouns: CSV!
    var adjectives: CSV!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read the CSV files.
        do {
            countries = try CSV(name: NSBundle.mainBundle().pathForResource("countries", ofType: "csv")!)
            states = try CSV(name: NSBundle.mainBundle().pathForResource("states", ofType: "csv")!)
            nouns = try CSV(name: NSBundle.mainBundle().pathForResource("nouns", ofType: "csv")!)
            adjectives = try CSV(name: NSBundle.mainBundle().pathForResource("adjectives", ofType: "csv")!)
        } catch {
            // Catch
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        nouns.enumerateAsDict { row in
            let entity =  NSEntityDescription.entityForName("Noun", inManagedObjectContext: managedContext)
            let noun = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Noun
            noun.word = row["word"]
            if let popularity = row["popularity"], num = Int32(popularity) {
                noun.popularity = NSNumber(int: num)
            }
            noun.code = row["code"]
            noun.kind = row["kind"]
        }
        
        adjectives.enumerateAsDict { row in
            let entity =  NSEntityDescription.entityForName("Adjective", inManagedObjectContext: managedContext)
            let adj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Adjective
            adj.word = row["word"]
            if let popularity = row["popularity"], num = Int32(popularity) {
                adj.popularity = NSNumber(int: num)
            }
            adj.code = row["code"]
            adj.kind = row["kind"]
        }
        
        countries.enumerateAsDict { row in
            let entity =  NSEntityDescription.entityForName("Country", inManagedObjectContext: managedContext)
            let country = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Country
            country.code = row["code"]
            country.name = row["name"]
            country.nameES = row["nameES"]
            country.lat = Double(row["lat"]!)!
            country.lon = Double(row["lng"]!)!
            country.bounds = row["bounds"]
            if let totalCombinations = row["popularity"], num = Int32(totalCombinations) {
                country.totalCombinations = NSNumber(int: num)
            }
        }
        
        states.enumerateAsDict { row in
            let entity =  NSEntityDescription.entityForName("State", inManagedObjectContext: managedContext)
            let state = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! State
            state.countryCode = row["countryCode"]
            state.countryName = row["countryName"]
            state.name1 = row["name1"]
            state.name2 = row["name2"]
            state.name3 = row["name3"]
            state.googleName = row["googleName"]
            state.googleAdmin = row["googleAdmin"]
            if let lat = row["lat"], num = Int32(lat) {
                state.lat = NSNumber(int: num)
            }
            if let lon = row["lng"], num = Int32(lon) {
                state.lon = NSNumber(int: num)
            }
            state.bounds = row["bounds"]
            if let totalCombinations = row["popularity"], num = Int32(totalCombinations) {
                state.totalCombinations = NSNumber(int: num)
            }
        }
        

        do {
            try managedContext.save()
            print("Saved in:", NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as String)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY!!!")
    }


}

