//
//  GithubAPI.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import Foundation
import Moya

// MARK: - Enums
enum GithubService {
    case emoji
    case avatar(username: String, page: Int? = nil, size: Int? = nil)
}

// MARK: - Extensions
extension GithubService: TargetType {
    var method: Moya.Method {
        switch self {
        case .emoji:
            return .get
        case .avatar(_, _, _):
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
        case .avatar(let username, let page, let size):
            if page != nil, size != nil {
                return "/users/\(username)/repos"
            } else {
                return "/users/\(username)"
            }
        }
    }
    
    var sampleData: Data {
        switch self {
        case .emoji:
            return ["image":"image.com"].jsonStringRepresentation?.data(using: .utf8) ?? Data()
        case .avatar(_, let page, let size):
            do {
                if page != nil, size != nil {
                    return try JSONEncoder().encode([Repo(id: 0, fullName: "Apple", privateRep: true)])
                } else {
                    return try JSONEncoder().encode(Avatar(login: "Yuri", avatarUrl: "yuri.com", id: 1))
                }
            } catch {
                return Data()
            }
        }
    }
    
    var task: Task {
        switch self {
        case .emoji:
            return .requestPlain
        case .avatar(_, let page, let size):
            if let page = page, let size = size {
                
                // I used per_page instead of size because it returns how many values I want, while size is 30 per request
                return .requestParameters(parameters: [
                    "per_page": size,
                    "page": page
                ], encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }   
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
