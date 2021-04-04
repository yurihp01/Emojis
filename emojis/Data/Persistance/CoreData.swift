//
//  EmojiCoreData.swift
//  emojis
//
//  Created by Yuri Pedroso on 02/04/21.
//

import UIKit
import CoreData

typealias EmojiType = [String:String]

final class CoreData {

    static let shared = CoreData()
    
    func saveUser(login: String, url: String, id: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "UserEntity", in: context) else { return }
            
            let user = NSManagedObject(entity: entityDescription, insertInto: context)
            user.setValue(login, forKey: "login")
            user.setValue(url, forKey: "url")
            user.setValue(id, forKey: "id")
            
            do {
                try context.save()
                print("User Saved")
            } catch {
                print("Error saving User")
            }
        }
    }
    
    func saveEmoji(name:String, link: String) {
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
    
    func retrieveEmoji() -> EmojiType {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Emoji>(entityName: "Emoji")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                var emoji: EmojiType = [:]
                for result in results {
                    if let link = result.link, let name = result.name {
                        emoji[name] = link
                        print("Name: \(name) - link: \(link)\n")
                    }
                }
                
                return emoji
            } catch {
                print("Couldn't retrieve Emoji values!")
            }
        }
        return [:]
    }
    
    func retrieveUser(login: String) -> User? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
            
            do {
                let results = try context.fetch(fetchRequest)

                guard let user = results.first(where: {
                    $0.login == login
                }).map({ User(login: $0.login ?? "", avatarUrl: $0.url ?? "", id: Int($0.id)) }) else { return nil }
                
                return user
            } catch {
                print("Couldn't retrieve User values!")
            }
        }
        return nil
    }
    
    func retrieveUsers() -> [User] {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
            
            do {
                let results = try context.fetch(fetchRequest)

                var users: [User] = []
                
                for result in results {
                    if let login = result.login, let avatarUrl = result.url {
                        let user = User(login: login, avatarUrl: avatarUrl, id: Int(result.id))
                        users.append(user)
                    }
                }
                
                return users
            } catch {
                print("Couldn't retrieve User values!")
            }
        }
        return []
    }
}
