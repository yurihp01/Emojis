//
//  Emoji.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

extension UIAlertController {
    static func showAlertDialog(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
