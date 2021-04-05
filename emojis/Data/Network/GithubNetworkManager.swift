//
//  GithubNetworkManager.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import Moya

protocol GithubNetworkManagerProtocol {
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void)
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void)
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void)
}

fileprivate let username = "apple"
fileprivate let size = 10

final class GithubNetworkManager: GithubNetworkManagerProtocol {
    static let shared = GithubNetworkManager()
    
    private let provider = MoyaProvider<GithubService>()
    
    private init() {}

    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        provider.request(.emoji) { (result) in
            switch result {
            case .success(let response):
                do {
                    let emoji = try JSONDecoder().decode(EmojiType.self, from: response.data)
                    response.statusCode == 200 ? completion(emoji, nil) : completion(nil, GithubError.notFound)
                } catch {
                    completion(nil, GithubError.jsonMapping)
                }
            case .failure:
                completion(nil, GithubError.internetConnection)
            }
        }
    }
    
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void) {
        provider.request(.avatar(username: username)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let avatar = try JSONDecoder().decode(Avatar.self, from: response.data)
                    response.statusCode == 200 ? completion(avatar, nil) : completion(nil, GithubError.notFound)
                } catch {
                    completion(nil, GithubError.jsonMapping)
                }
            case .failure:
                completion(nil, GithubError.internetConnection)
            }
        }
    }
    
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void) {
        provider.request(.avatar(username: username, page: page, size: size)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let repos = try JSONDecoder().decode([Repo].self, from: response.data)
                    response.statusCode == 200 ? completion(repos, nil) : completion(nil, GithubError.notFound)
                } catch {
                    completion(nil, GithubError.jsonMapping)
                }
            case .failure:
                completion(nil, GithubError.internetConnection)
            }
        }
    }

}
