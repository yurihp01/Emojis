//
//  Repository.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import Foundation

struct Repos: Codable {
    let repos: [Repo]
}

struct Repo {
    let id: Int
    let fullName: String
    let privateRep: Bool
    
    init(id: Int, fullName: String, privateRep: Bool) {
        self.id = id
        self.fullName = fullName
        self.privateRep = privateRep
    }
}

extension Repo: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case privateRep = "private"
    }
    
    init(from decoder: Decoder) throws {
        let repos = try decoder.container(keyedBy: CodingKeys.self)
        id = try repos.decode(Int.self, forKey: .id)
        fullName = try repos.decode(String.self, forKey: .fullName)
        privateRep = try repos.decode(Bool.self, forKey: .privateRep)
    }
}
