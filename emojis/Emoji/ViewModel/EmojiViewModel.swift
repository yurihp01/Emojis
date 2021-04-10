//
//  EmojiViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//
import Foundation

// MARK: - Protocols
protocol EmojiViewModelProtocol {
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void)
    func getAvatar(login: String, completion: @escaping (Avatar?, Error?) -> Void)
}

// MARK: - Class
class EmojiViewModel: EmojiViewModelProtocol {
    
    // MARK: - Variables
    var networkManager: GithubNetworkManagerProtocol
    var coreData: EmojisCoreDataProtocol
    
    // MARK: - Init and Deinit
    init() {
        networkManager = GithubNetworkManager.shared
        coreData = EmojisCoreData()
        
        print("INIT - EmojiViewModel")
    }
    
    deinit {
        print("DEINIT - EmojiViewModel")
    }
    
    // MARK: - Functions
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        do {
            let retrievedEmoji = try coreData.retrieveEmoji()
            if retrievedEmoji.isEmpty {
                networkManager.getEmojis(completion: { [weak self] (emoji, error) in
                    if let emoji = emoji {
                        emoji.forEach({
                            try? self?.coreData.saveEmoji(name: $0.key, link: $0.value)
                        })
                        completion(emoji, nil)
                    } else {
                        completion(nil, error)
                    }
                })
            } else {
                completion(retrievedEmoji, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func getAvatar(login: String, completion: @escaping (Avatar?, Error?) -> Void) {
        do {
            let retrievedAvatar = try coreData.retrieveAvatar(login: login)
            if retrievedAvatar == nil {
                networkManager.getAvatarByUsername(username: login) { [weak self] (avatar, error) in
                    if let avatar = avatar {
                        try? self?.coreData.saveAvatar(login: avatar.login, url: avatar.avatarUrl, id: avatar.id)
                        completion(avatar, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            } else {
                completion(retrievedAvatar, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
}
