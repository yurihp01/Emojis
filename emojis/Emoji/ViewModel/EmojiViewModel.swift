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
    func getUser(login: String, completion: @escaping (User?, Error?) -> Void)
}

class EmojiViewModel: EmojiViewModelProtocol {
    var user: User?
    var emoji: PublishSubject<EmojiType>
    
    init() {
        print("EmojiViewModel - INITIALIZATION")
        
        emoji = PublishSubject<EmojiType>()
    }
    
    deinit {
        print("EmojiViewModel - DEINITIALIZATION")
    }
    
    func getEmojis() {
        let retrievedEmoji = CoreData.shared.retrieveEmoji()
        if retrievedEmoji.isEmpty {
            GithubNetworkManager.shared.getEmojis()
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
    
    func getUser(login: String, completion: @escaping (User?, Error?) -> Void) {
        let retrievedUser = CoreData.shared.retrieveUser(login: login)
        if retrievedUser == nil {
            GithubNetworkManager.shared.getUserByUsername(username: login) { (user, error) in
                if let user = user {
                    CoreData.shared.saveUser(login: user.login, url: user.avatarUrl, id: user.id)
                    completion(user, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
        completion(retrievedUser, nil)
    }
}
