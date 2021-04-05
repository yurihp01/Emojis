//
//  GithubError.swift
//  emojis
//
//  Created by Yuri Pedroso on 01/04/21.
//

import Foundation

enum GithubError: Error {
    case notFound
    case jsonMapping
    case internetConnection
}

extension GithubError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Emojis Not Found. Contact with your app administrator."
        case .jsonMapping:
            return "Failed to map data to JSON object. Contact with your app administrator."
        case .internetConnection:
            return "The internet connection appers to be offline. Check your connection and try again."
        }
    }
}

