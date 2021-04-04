//
//  EmojiListViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit
import RxSwift

protocol EmojiListViewModelProtocol {
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void)
}

class EmojiListViewModel: EmojiListViewModelProtocol {
    
    var emoji: PublishSubject<EmojiType>
    
    init() {
        print("INIT - EmojiListViewController")
        self.emoji = PublishSubject<EmojiType>()
    }
    
    deinit {
        print("INIT - EmojiListViewController")
    }
//
//    func getEmojis() {
//        let retrievedEmoji = EmojiCoreData.shared.retrieveValues()
//        if retrievedEmoji.isEmpty {
//            GithubNetworkManager.shared.getEmojis()
//                .subscribe(onSuccess: { response in
//                    response.forEach {
//                        EmojiCoreData.shared.save(name: $0.key, link: $0.value)
//                    }
//                }, onError: { [weak self] error in
//                        self?.emoji.onError(error)
//                })
//        }
//        self.emoji.onNext(retrievedEmoji)
//        Observable.of(emoji).subscribe { [weak self](emoji) in
//            self?.emoji.onNext(emoji)
//        }
//    }
    
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        let retrievedEmoji = EmojiCoreData.shared.retrieveValues()
        if retrievedEmoji.isEmpty {
            GithubNetworkManager.shared.getEmojis()
                .subscribe(onSuccess: { response in
                    response.forEach {
                        EmojiCoreData.shared.save(name: $0.key, link: $0.value)
                    }
                }, onError: { error in
                    completion(nil, error)
                })
        }
        completion(retrievedEmoji, nil)
    }
}
