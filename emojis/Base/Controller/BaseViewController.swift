//
//  BaseViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

class BaseViewController: UIViewController, Storyboarded {
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.color = .white
        indicator.center = view.center
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicator)
    }
}
