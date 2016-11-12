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
        
        print("Please wait, creating Core Data database from CSV files...")
        
        // Read the CSV files.
        do {
            countries = try CSV(name: NSBundle.mainBundle().pathForResource("countries", ofType: "csv")!)
            states = try CSV(name: NSBundle.mainBundle().pathForResource("states", ofType: "csv")!)
            nouns = try CSV(name: NSBundle.mainBundle().pathForResource("en", ofType: "csv")!)
            adjectives = try CSV(name: NSBundle.mainBundle().pathForResource("adj_en", ofType: "csv")!)
        } catch {
            // Catch
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        nouns.enumerateAsDict { row in
            //word,popularity,code,type
            let entity =  NSEntityDescription.entityForName("XANoun", inManagedObjectContext: managedContext)
            let noun = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! XANoun
            noun.word = row["word"]
            if let popularity = row["popularity"], num = Int32(popularity) {
                noun.popularity = NSNumber(int: num)
            }
            noun.code = row["code"]
            noun.kind = row["type"]
        }
        
        adjectives.enumerateAsDict { row in
            //word,popularity,code,type
            let entity =  NSEntityDescription.entityForName("XAAdjective", inManagedObjectContext: managedContext)
            let adj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! XAAdjective
            adj.word = row["word"]
            if let popularity = row["popularity"], num = Int32(popularity) {
                adj.popularity = NSNumber(int: num)
            }
            adj.code = row["code"]
            adj.kind = row["type"]
        }
        
        countries.enumerateAsDict { row in
            //countryCode,countryName,Nombre,lat,lng,bounds,combinaciones,tipo
            let entity =  NSEntityDescription.entityForName("XACountry", inManagedObjectContext: managedContext)
            let country = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! XACountry
            country.code = row["countryCode"]
            country.name = row["countryName"]
            country.nameES = row["Nombre"]
            country.lat = Double(row["lat"]!)!
            country.lon = Double(row["lng"]!)!
            country.bounds = row["bounds"]
            if let totalCombinations = row["combinaciones"], num = Int32(totalCombinations) {
                country.totalCombinations = NSNumber(int: num)
            }
            country.kind = row["tipo"]
        }
        
        states.enumerateAsDict { row in
            //countryCode,stateCode,stateName1,stateName2,stateName3,googleName,googleAdmin,countryName,lat,lng,bounds,combinaciones
            let entity =  NSEntityDescription.entityForName("XAState", inManagedObjectContext: managedContext)
            let state = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! XAState
            state.countryCode = row["countryCode"]
            state.countryName = row["countryName"]
            state.name1 = row["stateName1"]
            state.name2 = row["stateName2"]
            state.name3 = row["stateName3"]
            state.googleName = row["googleName"]
            state.googleAdmin = row["googleAdmin"]
            if let lat = row["lat"], num = Int32(lat) {
                state.lat = NSNumber(int: num)
            }
            if let lon = row["lng"], num = Int32(lon) {
                state.lon = NSNumber(int: num)
            }
            state.bounds = row["bounds"]
            if let totalCombinations = row["combinaciones"], num = Int32(totalCombinations) {
                state.totalCombinations = NSNumber(int: num)
            }
        }
        

        do {
            try managedContext.save()
            print("Created successfully in:\n", NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as String)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY!!!")
    }


}

