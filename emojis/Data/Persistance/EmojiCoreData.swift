//
//  EmojiCoreData.swift
//  emojis
//
//  Created by Yuri Pedroso on 02/04/21.
//

import UIKit
import CoreData

typealias EmojiType = [String:String]

final class EmojiCoreData {

    static let shared = EmojiCoreData()
    
    func save(name:String, link: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Emoji", in: context) else { return }
            
            let emoji = NSManagedObject(entity: entityDescription, insertInto: context)
            emoji.setValue(name, forKey: "name")
            emoji.setValue(link, forKey: "link")
            
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Error")
            }
        }
    }
    
    func retrieveValues() -> EmojiType {
        if let appDelegate = UIApplication.shared
            .delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Emoji>(entityName: "Emoji")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                var emoji: EmojiType = [:]
                for result in results {
                    if let link = result.link, let name = result.name {
                        print("Name: \(name) - link: \(link)\n")
                        emoji[name] = link
                    }
                }
                
                return emoji
            } catch {
                print("Couldn't retrieve values!")
            }
        }
        return [:]
    }
}
