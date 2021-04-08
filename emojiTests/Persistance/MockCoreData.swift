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
    
    enum Status {
        case success
        case saveError
        case deleteError
        case retrieveError
    }
    
    let status: Status
    
    init(status: Status) {
        self.status = status
    }
    
    var avatars: [Avatar] = []
    var emoji: EmojiType = [:]
    
    func saveAvatar(login: String, url: String, id: Int) throws {
        switch status {
        case .success:
            avatars.append(Avatar(login: login, avatarUrl: url, id: id))
        case .deleteError:
            throw CoreDataError.delete
        case .retrieveError:
            throw CoreDataError.retrieve
        case .saveError:
            throw CoreDataError.save
        }
    }
    
    func saveEmoji(name: String, link: String) throws {
        switch status {
        case .success:
            emoji[name] = link
        case .deleteError:
            throw CoreDataError.delete
        case .retrieveError:
            throw CoreDataError.retrieve
        case .saveError:
            throw CoreDataError.save
        }
    }
    
    func retrieveEmoji() throws -> EmojiType {
        switch status {
        case .success:
            return emoji
        case .deleteError:
            throw CoreDataError.delete
        case .retrieveError:
            throw CoreDataError.retrieve
        case .saveError:
            throw CoreDataError.save
        }
    }
    
    func retrieveAvatar(login: String) throws -> Avatar? {
        switch status {
        case .success:
            return avatars.first(where: { $0.login == login })
        case .deleteError:
            throw CoreDataError.delete
        case .retrieveError:
            throw CoreDataError.retrieve
        case .saveError:
            throw CoreDataError.save
        }
    }
    
    func retrieveAvatarsUrl() throws -> [String] {
        switch status {
        case .success:
            return avatars.compactMap({ $0.avatarUrl })
        case .deleteError:
            throw CoreDataError.delete
        case .retrieveError:
            throw CoreDataError.retrieve
        case .saveError:
            throw CoreDataError.save
        }
    }
    
    func deleteAvatar(url: String) throws {
        switch status {
        case .success:
            return avatars.removeAll(where: { $0.avatarUrl == url })
        case .deleteError:
            throw CoreDataError.delete
        case .retrieveError:
            throw CoreDataError.retrieve
        case .saveError:
            throw CoreDataError.save
        }
    }
}
