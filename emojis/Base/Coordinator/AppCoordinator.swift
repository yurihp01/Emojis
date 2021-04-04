//
//  AppCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init() {
        navigationController = UINavigationController()
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.3050227463, green: 0.3966548443, blue: 0.6912810802, alpha: 1)
    }
    
    func start() {
        let childCoordinator = EmojiCoordinator(navigationController: navigationController)
        childCoordinator.parentCoordinator = self
        add(childCoordinator: childCoordinator)
        childCoordinator.start()
    }
    

}
