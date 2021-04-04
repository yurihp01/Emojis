//
//  User.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import Foundation

struct User {
    let avatarUrl: String
    let login: String
    let id: Int
    
    var url: URL? {
        return URL(string: avatarUrl)
    }
    
    init(login: String, avatarUrl: String, id: Int) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.id = id
    }
}

extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
        case id
    }
    
    init(from decoder: Decoder) throws {
        let user = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try user.decode(String.self, forKey: .avatarUrl)
        id = try user.decode(Int.self, forKey: .id)
        login =  try user.decode(String.self, forKey: .login)
    }
}
