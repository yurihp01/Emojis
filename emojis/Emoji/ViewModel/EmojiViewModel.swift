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
        print("EmojiViewModel - INITIALIZATION")
        
        githubManager = GithubNetworkManager.shared
    }
    
    deinit {
        print("EmojiViewModel - DEINITIALIZATION")
    }
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        let retrievedEmoji = CoreData.shared.retrieveEmoji()
        if retrievedEmoji.isEmpty {
            GithubNetworkManager.shared.getEmojis(completion: { (emoji, error) in
                if let emoji = emoji {
                    emoji.forEach({
                        CoreData.shared.saveEmoji(name: $0.key, link: $0.value)
                    })
                    completion(emoji, nil)
                } else {
                    completion(nil, error)
                }
            })
        }
        completion(retrievedEmoji, nil)
    }
    
    func getUser(login: String, completion: @escaping (Avatar?, Error?) -> Void) {
        let retrievedAvatar = CoreData.shared.retrieveAvatar(login: login)
        if retrievedAvatar == nil {
            githubManager.getAvatarByUsername(username: login) { (avatar, error) in
                if let avatar = avatar {
                    CoreData.shared.saveAvatar(login: avatar.login, url: avatar.avatarUrl, id: avatar.id)
                    completion(avatar, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
        completion(retrievedAvatar, nil)
    }
    
    
}
