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
            .subscribe(onSuccess: { [weak self] response in
                response.forEach {
                    EmojiCoreData.shared.save(name: $0.key, link: $0.value)
                }
                
                // check if core data retrieves all emojis.
                    EmojiCoreData.shared.retrieveValues()
            }, onError: { [weak self] error in
                    self?.emoji.onError(error)
            })
    }
}
