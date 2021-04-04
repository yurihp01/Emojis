//
//  EmojiListCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

class EmojiListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = EmojiListViewController.instantiate(storyboardName: "EmojiList")
        viewController.viewModel = EmojiListViewModel()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
