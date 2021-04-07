//
//  EmojiCoreData.swift
//  emojis
//
//  Created by Yuri Pedroso on 02/04/21.
//

import UIKit
import CoreData

typealias EmojiType = [String:String]

protocol EmojisCoreDataProtocol {
    func saveAvatar(login: String, url: String, id: Int) throws
    func saveEmoji(name:String, link: String) throws
    func retrieveEmoji() throws -> EmojiType
    func retrieveAvatar(login: String) throws -> Avatar?
    func retrieveAvatarsUrl() throws -> [String]
    func deleteAvatar(url: String) throws
}

final class EmojisCoreData: EmojisCoreDataProtocol {

    static let shared = EmojisCoreData()
    
    func saveAvatar(login: String, url: String, id: Int) throws {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "AvatarEntity", in: context) else { return }
            
            let user = NSManagedObject(entity: entityDescription, insertInto: context)
            user.setValue(login, forKey: "login")
            user.setValue(url, forKey: "url")
            user.setValue(id, forKey: "id")
            
            do {
                try context.save()
            } catch {
                throw CoreDataError.save
            }
        }
    }
    
    func saveEmoji(name:String, link: String) throws {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Emoji", in: context) else { return }
            
            let emoji = NSManagedObject(entity: entityDescription, insertInto: context)
            emoji.setValue(name, forKey: "name")
            emoji.setValue(link, forKey: "link")
            
            do {
                try context.save()
            } catch {
                throw CoreDataError.save
            }
        }
    }
    
    func retrieveEmoji() throws -> EmojiType {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Emoji>(entityName: "Emoji")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                var emoji: EmojiType = [:]
                for result in results {
                    if let link = result.link, let name = result.name {
                        emoji[name] = link
                    }
                }
                
                return emoji
            } catch {
                throw CoreDataError.retrieve
            }
        }
        return [:]
    }
    
    func retrieveAvatar(login: String) throws -> Avatar? {
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
                throw CoreDataError.retrieve
            }
        }
        return nil
    }
    
    func retrieveAvatarsUrl() throws -> [String] {
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
                throw CoreDataError.retrieve
            }
        }
        return []
    }
    
    func deleteAvatar(url: String) throws {
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
                throw CoreDataError.delete
            }
        }
    }
}
