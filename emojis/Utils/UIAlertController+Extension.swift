//
//  Emoji.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

extension UIAlertController {
    // MARK: - Functions
    static func showAlertDialog(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okButton, style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
