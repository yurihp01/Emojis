//
//  MockCoreData.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 05/04/21.
//

import Nimble
import Quick
import CoreData
@testable import emojis

// MARK: - Class
class MockCoreData: EmojisCoreDataProtocol {
    
    // MARK: - Enums
    enum Status {
        case success
        case saveError
        case deleteError
        case retrieveError
    }
    
    // MARK: - Variables
    let status: Status
    
    var avatars: [Avatar] = []
    var emoji: EmojiType = [:]
    
    // MARK: - Init
    init(status: Status) {
        self.status = status
    }
    
    // MARK: - Functions
    func saveAvatar(login: String, url: String, id: Int) throws {
        switch status {
        case .success:
            avatars.append(Avatar(login: login, avatarUrl: url, id: id))
        default:
            throw CoreDataError.save
        }
    }
    
    func saveEmoji(name: String, link: String) throws {
        switch status {
        case .success:
            emoji[name] = link
        default:
            throw CoreDataError.save
        }
    }
    
    func retrieveEmoji() throws -> EmojiType {
        switch status {
        case .success:
            return emoji
        default:
            throw CoreDataError.retrieve
        
        }
    }
    
    func retrieveAvatar(login: String) throws -> Avatar? {
        switch status {
        case .success:
            return avatars.first(where: { $0.login == login })
        default:
            throw CoreDataError.retrieve
        }
    }
    
    func retrieveAvatarsUrl() throws -> [String] {
        switch status {
        case .success:
            return avatars.compactMap({ $0.avatarUrl })
        default:
            throw CoreDataError.retrieve
        }
    }
    
    func deleteAvatar(url: String) throws {
        switch status {
        case .success:
            return avatars.removeAll(where: { $0.avatarUrl == url })
        default:
            throw CoreDataError.delete
        }
    }
}
