//
//  CoreDataError.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import Foundation

enum CoreDataError: Error {
    case save
    case retrieve
    case delete
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .save:
            return "An error occurred while saving data. Check with your app administrator and try again."
        case .retrieve:
            return "An error occurred while retrieving data. Check with your app administrator and try again."
        case .delete:
            return "An error occurred while deleting data. Check with your app administrator and try again."
        }
    }
}
