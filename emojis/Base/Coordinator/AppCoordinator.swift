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
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let childCoordinator = EmojiCoordinator(navigationController: navigationController)
        childCoordinator.parentCoordinator = self
        add(childCoordinator: childCoordinator)
        childCoordinator.start()
    }
    

}
