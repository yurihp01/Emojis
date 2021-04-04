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
}
