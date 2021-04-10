//
//  GithubNetworkManager.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import Moya

// MARK: - Protocols
protocol GithubNetworkManagerProtocol {
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void)
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void)
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void)
}

// MARK: - FilePrivate Constant
fileprivate let username = "apple"
fileprivate let size = 10

// MARK: - Class
final class GithubNetworkManager: GithubNetworkManagerProtocol {
    
    // MARK: - Variables
    static let shared = GithubNetworkManager()
    
    var provider = MoyaProvider<GithubService>()
    
    // MARK: - Init
    private init() {}

    // MARK: - Functions
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        provider.request(.emoji) { (result) in
            switch result {
            case .success(let response):
                do {
                    let emoji = try JSONDecoder().decode(EmojiType.self, from: response.data)
                    
                    // I needed to check the status code later because the response returns the same type for both. So, if its code is 200, it returns the emoji, otherwise, the error.
                    response.statusCode == 200 ? completion(emoji, nil) : completion(nil, GithubError.notFound(name: "Emoji"))
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
                    if response.statusCode == 200 {
                        let avatar = try JSONDecoder().decode(Avatar.self, from: response.data)
                        completion(avatar, nil)
                    } else {
                        completion(nil, GithubError.notFound(name: "Avatar"))
                    }
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
                    if response.statusCode == 200 {
                        let repos = try JSONDecoder().decode([Repo].self, from: response.data)
                        completion(repos, nil)
                    } else {
                        completion(nil, GithubError.notFound(name: "Repos"))
                    }
                } catch {
                    completion(nil, GithubError.jsonMapping)
                }
            case .failure:
                completion(nil, GithubError.internetConnection)
            }
        }
    }

}
