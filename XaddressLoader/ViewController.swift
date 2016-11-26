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
    @IBOutlet weak var statusLabel: UILabel!
    
    var countries: CSV!
    var states: CSV!
    var nouns: CSV!
    var adjectives: CSV!
    var images: CSV!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statusLabel.text = "Please wait, creating Core Data database from CSV files..."
        print(self.statusLabel.text!)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            // Read the CSV files.
            do {
                self.countries = try CSV(name: NSBundle.mainBundle().pathForResource("countries", ofType: "csv")!)
                self.states = try CSV(name: NSBundle.mainBundle().pathForResource("states", ofType: "csv")!)
                self.nouns = try CSV(name: NSBundle.mainBundle().pathForResource("en", ofType: "csv")!)
                self.adjectives = try CSV(name: NSBundle.mainBundle().pathForResource("adj_en", ofType: "csv")!)
                self.images = try CSV(name: NSBundle.mainBundle().pathForResource("images", ofType: "csv")!)
            } catch {
                // Catch
            }
            
            self.images.enumerateAsDict { row in
                //index,en,es
                let entity =  NSEntityDescription.entityForName("XAImage", inManagedObjectContext: moc)
                let image = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! XAImage
                image.index = Int(row["index"]!)
                image.en = row["en"]
                image.es = row["es"]
            }
            

            self.nouns.enumerateAsDict { row in
                //word,popularity,code,type
                let entity =  NSEntityDescription.entityForName("XANoun", inManagedObjectContext: moc)
                let noun = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! XANoun
                noun.word = row["word"]
                if let popularity = row["popularity"], num = Int32(popularity) {
                    noun.popularity = NSNumber(int: num)
                }
                noun.code = row["code"]
                noun.kind = row["type"]
            }
            
            self.adjectives.enumerateAsDict { row in
                //word,popularity,code,type
                let entity =  NSEntityDescription.entityForName("XAAdjective", inManagedObjectContext: moc)
                let adj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! XAAdjective
                adj.word = row["word"]
                if let popularity = row["popularity"], num = Int32(popularity) {
                    adj.popularity = NSNumber(int: num)
                }
                adj.code = row["code"]
                adj.kind = row["type"]
            }
            
            self.countries.enumerateAsDict { row in
                //countryCode,countryName,Nombre,lat,lng,bounds,combinaciones,tipo
                let entity =  NSEntityDescription.entityForName("XACountry", inManagedObjectContext: moc)
                let country = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! XACountry
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
            
            self.states.enumerateAsDict { row in
                //countryCode,stateCode,stateName1,stateName2,stateName3,googleName,googleAdmin,countryName,lat,lng,bounds,combinaciones
                let entity =  NSEntityDescription.entityForName("XAState", inManagedObjectContext: moc)
                let state = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! XAState
                state.countryCode = row["countryCode"]
                state.code = row["stateCode"]
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
            
            
            dispatch_async(dispatch_get_main_queue(), {
                do {
                    try moc.save()
                    self.statusLabel.text = "Created successfully, open the Xcode log for the path to database file."
                    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as String
                    print("Created successfully in:\n" + path)
                    
                    print("\nCopy the files:\n")
                    let files = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
                    for file in files {
                        print(file)
                    }
                    print("\ninto the main Xaddress Xcode project.")
                    
                    
                } catch let error as NSError  {
                    self.statusLabel.text = "Could not save \(error), \(error.userInfo)"
                    print(self.statusLabel.text!)
                }
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY WARNING")
    }
}

