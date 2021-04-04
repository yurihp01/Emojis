//
//  AvatarCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import UIKit

class AvatarCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = AvatarViewController.instantiate(storyboardName: "Avatar")
        viewController.coordinator = self
        viewController.viewModel = AvatarViewModel()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
