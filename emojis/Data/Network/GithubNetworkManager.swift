//
//  GithubNetworkManager.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import RxSwift
import Moya

protocol GithubNetworkManagerProtocol {
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void)
    func getEmojis() -> Single<EmojiType>
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void)
}

fileprivate let username = "apple"
fileprivate let size = 10

final class GithubNetworkManager: GithubNetworkManagerProtocol {
    static let shared = GithubNetworkManager()
    
    private let provider = MoyaProvider<GithubService>()
    
    private init() {}

    func getEmojis() -> Single<EmojiType> {
        provider.rx.request(.emoji)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(EmojiType.self)
    }
    
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void) {
        provider.request(.avatar(username: username)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let avatar = try JSONDecoder().decode(Avatar.self, from: response.data)
                    completion(avatar, nil)
                } catch {
                    print(error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void) {
        provider.request(.avatar(username: username, page: page, size: size)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let repos = try JSONDecoder().decode([Repo].self, from: response.data)
                    completion(repos, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

}
