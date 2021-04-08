//
//  MockNetworkManager.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 06/04/21.
//

import Nimble
import Quick
@testable import emojis

class GithubNetworkManagerMock: GithubNetworkManagerProtocol {
    enum Status {
        case success
        case notFound(name: String)
        case jsonMapping
        case internetConnection
    }
    
    private let status: Status
    
    init(status: Status) {
        self.status = status
    }
    
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void) {
        switch status {
        case .success:
            completion(Avatar(login: "Avatar", avatarUrl: "Avatar", id: 1), nil)
        case .internetConnection:
            completion(nil, GithubError.internetConnection)
        case .jsonMapping:
            completion(nil, GithubError.jsonMapping)
        case .notFound(let name):
            completion(nil, GithubError.notFound(name: name))
        }
    }
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        switch status {
        case .success:
            completion(["Emoji":"Emoji"], nil)
        case .internetConnection:
            completion(nil, GithubError.internetConnection)
        case .jsonMapping:
            completion(nil, GithubError.jsonMapping)
        case .notFound(let name):
            completion(nil, GithubError.notFound(name: name))
        }
    }
    
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void) {
        switch status {
        case .success:
            completion([Repo(id: 1, fullName: "Repo", privateRep: true)], nil)
        case .internetConnection:
            completion(nil, GithubError.internetConnection)
        case .jsonMapping:
            completion(nil, GithubError.jsonMapping)
        case .notFound(let name):
            completion(nil, GithubError.notFound(name: name))
        }
    }
}
