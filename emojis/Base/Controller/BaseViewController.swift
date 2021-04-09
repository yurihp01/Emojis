//
//  BaseViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

class BaseViewController: UIViewController, Storyboarded {
    
    lazy var indicator: UIActivityIndicatorView = {
      let percent = view.bounds.height - view.bounds.height * 0.2
      let indicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x - 24, y: percent, width: 40, height: 40))
        indicator.color = .white
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicator)
    }
    
    func showAlert(error: Error?) {
        guard let error = error else { return }
        let alert = UIAlertController.showAlertDialog(title: "Error 🥺", message: error.localizedDescription)
        self.present(alert, animated: true, completion: nil)
    }
}
