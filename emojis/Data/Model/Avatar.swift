//
//  User.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import Foundation

struct Avatar {
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

extension Avatar: Codable {
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
        case id
    }
    
    init(from decoder: Decoder) throws {
        let avatar = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try avatar.decode(String.self, forKey: .avatarUrl)
        id = try avatar.decode(Int.self, forKey: .id)
        login =  try avatar.decode(String.self, forKey: .login)
    }
}
