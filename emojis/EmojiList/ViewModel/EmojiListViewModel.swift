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
        print("INIT - EmojiListViewController")
    }
    
    deinit {
        print("INIT - EmojiListViewController")
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
}
