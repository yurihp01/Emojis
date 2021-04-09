//
//  EmojiCoordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//
import UIKit

class EmojiCoordinator: Coordinator {
    
    // MARK: - Variables
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    func start() {
        let viewController = EmojiViewController.instantiate(storyboardName: .emoji)
        viewController.viewModel = EmojiViewModel()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - Extensions
extension EmojiCoordinator: EmojiProtocol {
    func avatarsList() {
        let coordinator = AvatarCoordinator(with: navigationController)
        coordinator.parentCoordinator = self
        add(childCoordinator: coordinator)
        coordinator.start()
    }
    
    func emojisList() {
        let coordinator = EmojiListCoordinator(navigationController)
        coordinator.parentCoordinator = self
        add(childCoordinator: coordinator)
        coordinator.start()
    }
    
    func reposList() {
        let coordinator = ReposCoordinator(with: navigationController)
        coordinator.parentCoordinator = self
        add(childCoordinator: coordinator)
        coordinator.start()
    }
}
