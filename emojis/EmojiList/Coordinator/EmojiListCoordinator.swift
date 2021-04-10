//
//  EmojiListCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

// MARK: - Class
class EmojiListCoordinator: Coordinator {
    
    // MARK: - Variables
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    // MARK: - Initialization
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    func start() {
        let viewController = EmojiListViewController.instantiate(storyboardName: .emojiList)
        viewController.viewModel = EmojiListViewModel()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
