//
//  GithubError.swift
//  emojis
//
//  Created by Yuri Pedroso on 01/04/21.
//

import Foundation

// MARK: Enums
enum GithubError: Error {
    case notFound(name: String)
    case jsonMapping
    case internetConnection
}

// MARK: Extensions
extension GithubError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFound(let name):
            return "\(name) not found. Contact with your app administrator."
        case .jsonMapping:
            return "Failed to map data to JSON object. Contact with your app administrator."
        case .internetConnection:
            return "The internet connection appears to be offline. Check your connection and try again."
        }
    }
}

