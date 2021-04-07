//
//  EmojiListViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

protocol EmojiListViewModelProtocol {
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void)
}

class EmojiListViewModel: EmojiListViewModelProtocol {
    
    var networkManager: GithubNetworkManagerProtocol
    var coreData: EmojisCoreDataProtocol
    
    init() {
        print("INIT - EmojiListViewModel")
        
        coreData = EmojisCoreData.shared
        networkManager = GithubNetworkManager.shared
    }
    
    deinit {
        print("DEINIT - EmojiListViewModel")
    }
    
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
}
