//
//  EmojiCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//
import UIKit

class EmojiCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = EmojiViewController.instantiate(storyboardName: "Emoji")
        viewController.viewModel = EmojiViewModel()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
