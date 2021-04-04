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
    func getUser(login: String, completion: @escaping (Avatar?, Error?) -> Void)
}

class EmojiViewModel: EmojiViewModelProtocol {
    var emoji: PublishSubject<EmojiType>
    
    let githubManager: GithubNetworkManagerProtocol
    
    init() {
        print("EmojiViewModel - INITIALIZATION")
        
        emoji = PublishSubject<EmojiType>()
        githubManager = GithubNetworkManager.shared
    }
    
    deinit {
        print("EmojiViewModel - DEINITIALIZATION")
    }
    
    func getEmojis() {
        let retrievedEmoji = CoreData.shared.retrieveEmoji()
        if retrievedEmoji.isEmpty {
            githubManager.getEmojis()
                .subscribe(onSuccess: { response in
                    response.forEach {
                        CoreData.shared.saveEmoji(name: $0.key, link: $0.value)
                    }
                }, onError: { [weak self] error in
                        self?.emoji.onError(error)
                }).disposed(by: DisposeBag())
        }
        self.emoji.onNext(retrievedEmoji)
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
