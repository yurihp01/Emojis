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
    
    func saveAvatar(login: String, url: String, id: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "AvatarEntity", in: context) else { return }
            
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
    
    func retrieveAvatar(login: String) -> Avatar? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<AvatarEntity>(entityName: "AvatarEntity")
            
            do {
                let results = try context.fetch(fetchRequest)

                guard let user = results.first(where: {
                    $0.login == login
                }).map({ Avatar(login: $0.login ?? "", avatarUrl: $0.url ?? "", id: Int($0.id)) }) else { return nil }
                
                return user
            } catch {
                print("Couldn't retrieve Avatar values!")
            }
        }
        return nil
    }
    
    func retrieveAvatarsUrl() -> [String] {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<AvatarEntity>(entityName: "AvatarEntity")
            
            do {
                let results = try context.fetch(fetchRequest)

                var urls: [String] = []
                
                for result in results {
                    if let avatarUrl = result.url {
                        urls.append(avatarUrl)
                    }
                }
                
                return urls
            } catch {
                print("Couldn't retrieve Avatar values!")
            }
        }
        return []
    }
    
    func deleteAvatar(url: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<AvatarEntity>(entityName: "AvatarEntity")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if result.url == url {
                        context.delete(result)
                    }
                }
                
                try context.save()
            } catch {
                print("Couldn't delete Avatar!")
            }
        }
    }
}
