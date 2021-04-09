//
//  AvatarCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import UIKit

class AvatarCoordinator: Coordinator {
    
    // MARK: - Variables
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    // MARK: - Initialization
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    func start() {
        let viewController = AvatarViewController.instantiate(storyboardName: .avatar)
        viewController.coordinator = self
        viewController.viewModel = AvatarViewModel()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
