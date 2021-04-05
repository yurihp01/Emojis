//
//  EmojiViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//
import Foundation

protocol EmojiViewModelProtocol {
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void)
    func getUser(login: String, completion: @escaping (Avatar?, Error?) -> Void)
}

class EmojiViewModel: EmojiViewModelProtocol {
    let githubManager: GithubNetworkManagerProtocol
    
    init() {
        githubManager = GithubNetworkManager.shared
        print("INIT - EmojiViewModel")
    }
    
    deinit {
        print("DEINIT - EmojiViewModel")
    }
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        do {
            let retrievedEmoji = try EmojisCoreData.shared.retrieveEmoji()
            if retrievedEmoji.isEmpty {
                GithubNetworkManager.shared.getEmojis(completion: { (emoji, error) in
                    if let emoji = emoji {
                        emoji.forEach({
                                try? EmojisCoreData.shared.saveEmoji(name: $0.key, link: $0.value)
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
    
    func getUser(login: String, completion: @escaping (Avatar?, Error?) -> Void) {
        do {
            let retrievedAvatar = try EmojisCoreData.shared.retrieveAvatar(login: login)
            if retrievedAvatar == nil {
                githubManager.getAvatarByUsername(username: login) { (avatar, error) in
                    if let avatar = avatar {
                        try? EmojisCoreData.shared.saveAvatar(login: avatar.login, url: avatar.avatarUrl, id: avatar.id)
                        completion(avatar, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            }
            completion(retrievedAvatar, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    
}
