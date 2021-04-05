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
    init() {
        print("INIT - EmojiListViewModel")
    }
    
    deinit {
        print("DEINIT - EmojiListViewModel")
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
}
