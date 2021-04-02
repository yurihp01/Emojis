//
//  EmojiViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import RxSwift

protocol EmojiViewModelProtocol {
    var emoji: PublishSubject<[String:String]> { get set }
    func getEmojis()
}

class EmojiViewModel: EmojiViewModelProtocol {
    var emoji: PublishSubject<[String:String]>
    
    init() {
        print("EmojiViewModel - INITIALIZATION")
        
        emoji = PublishSubject<[String:String]>()
    }
    
    deinit {
        print("EmojiViewModel - DEINITIALIZATION")
    }
    
    func getEmojis() {
        GithubNetworkManager.shared.getEmojis()
        .subscribe { data in
            self.emoji.onNext(data)
        } onError: { error in
            self.emoji.onError(error)
        }
    }
}
