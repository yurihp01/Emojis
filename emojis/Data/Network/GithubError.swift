//
//  GithubError.swift
//  emojis
//
//  Created by Yuri Pedroso on 01/04/21.
//

import Foundation

enum GithubError: Error {
    case notFound
}

extension GithubError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Not Found"
        }
    }
}

