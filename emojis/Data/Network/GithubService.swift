//
//  GithubAPI.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import Foundation
import Moya

enum GithubService {
    case emoji
    case user(username: String)
}

extension GithubService: TargetType {
    var method: Moya.Method {
        switch self {
        case .emoji:
            return .get
        case .user(_):
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .emoji:
            return "/emojis"
        case .user(let username):
            return"/users/\(username)"
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
