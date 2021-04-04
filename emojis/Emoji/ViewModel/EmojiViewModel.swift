//
//  EmojiViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//
import RxSwift

protocol EmojiViewModelProtocol {
    var emoji: PublishSubject<EmojiType> { get set }
    func getEmojis()
}

class EmojiViewModel: EmojiViewModelProtocol {
    var emoji: PublishSubject<EmojiType>
    
    init() {
        print("EmojiViewModel - INITIALIZATION")
        
        emoji = PublishSubject<EmojiType>()
    }
    
    deinit {
        print("EmojiViewModel - DEINITIALIZATION")
    }
    
    func getEmojis() {
        let retrievedEmoji = EmojiCoreData.shared.retrieveValues()
        if retrievedEmoji.isEmpty {
            GithubNetworkManager.shared.getEmojis()
                .subscribe(onSuccess: { response in
                    response.forEach {
                        EmojiCoreData.shared.save(name: $0.key, link: $0.value)
                    }
                }, onError: { [weak self] error in
                        self?.emoji.onError(error)
                })
        }
        self.emoji.onNext(retrievedEmoji)
    }
}
