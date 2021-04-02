//
//  Storyboarded.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName name: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboardName name: String) -> Self {
        let fullName = NSStringFromClass(self)
        
        // we need to get the value at position 1 because it's the view controller name.
        let className = fullName.components(separatedBy: ".")[1]
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
