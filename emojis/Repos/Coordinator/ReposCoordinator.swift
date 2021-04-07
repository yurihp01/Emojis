//
//  ReposCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import UIKit

class ReposCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ReposViewController.instantiate(storyboardName: "Repos")
        viewController.coordinator = self
        viewController.viewModel = ReposViewModel()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    

}
