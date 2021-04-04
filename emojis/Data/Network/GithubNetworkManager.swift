//
//  GithubNetworkManager.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import RxSwift
import Moya

struct GithubNetworkManager {
    static let shared = GithubNetworkManager()
    
    private let provider = MoyaProvider<GithubService>()
    
    func getEmojis() -> Single<EmojiType> {
        provider.rx.request(.emoji)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(EmojiType.self)
    }
    
    func getUserByUsername(username: String, completion: @escaping (User?, Error?) -> Void) {
        provider.request(.user(username: username)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let x = try JSONDecoder().decode(User.self, from: response.data)
                    completion(x, nil)
                } catch {
                    print(error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
