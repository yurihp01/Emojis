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

class MockCoreData: EmojisCoreDataProtocol {
    var avatars: [Avatar] = []
    var emoji: EmojiType = [:]
    
    func saveAvatar(login: String, url: String, id: Int) throws {
        avatars.append(Avatar(login: login, avatarUrl: url, id: id))
    }
    
    func saveEmoji(name: String, link: String) throws {
        emoji[name] = link
    }
    
    func retrieveEmoji() throws -> EmojiType {
        return emoji
    }
    
    func retrieveAvatar(login: String) throws -> Avatar? {
        avatars.first(where: { $0.login == login })
    }
    
    func retrieveAvatarsUrl() throws -> [String] {
        avatars.compactMap({ $0.avatarUrl })
    }
    
    func deleteAvatar(url: String) throws {
        avatars.removeAll(where: { $0.avatarUrl == url })
    }
}

class MockCoreDataError: EmojisCoreDataProtocol {
    var avatars: [Avatar] = []
    var emoji: EmojiType = [:]
    
    func saveAvatar(login: String, url: String, id: Int) throws {
        throw CoreDataError.save
    }
    
    func saveEmoji(name: String, link: String) throws {
        throw CoreDataError.save
    }
    
    func retrieveEmoji() throws -> EmojiType {
        throw CoreDataError.retrieve
    }
    
    func retrieveAvatar(login: String) throws -> Avatar? {
        throw CoreDataError.retrieve
    }
    
    func retrieveAvatarsUrl() throws -> [String] {
        throw CoreDataError.retrieve
    }
    
    func deleteAvatar(url: String) throws {
        throw CoreDataError.delete
    }
}
