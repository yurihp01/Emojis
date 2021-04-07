//
//  Dictionary+Extension.swift
//  emojis
//
//  Created by Yuri Pedroso on 06/04/21.
//

import Foundation

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}
