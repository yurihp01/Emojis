//
//  BaseViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

class BaseViewController: UIViewController, Storyboarded {
    
    // MARK: Variables
    lazy var indicator: UIActivityIndicatorView = {
        let percent = view.bounds.height - view.bounds.height * 0.2
        let indicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x - 24, y: percent, width: 40, height: 40))
        indicator.accessibilityIdentifier = Constants.indicator
        indicator.color = .white
        indicator.style = .whiteLarge
        indicator.hidesWhenStopped = true
        return indicator
    } ()
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicator)
    }
    
    // MARK: - Functions
    func showAlert(message: String?) {
        guard let message = message else { return }
        let alert = UIAlertController.showAlertDialog(title: Constants.titleError, message: message)
        self.present(alert, animated: true, completion: nil)
    }
}
