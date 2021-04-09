//
//  Coordinator.swift
//  emojis
//
//  Created by Yuri Pedroso on 31/03/21.
//

import UIKit

// MARK: - Protocols
protocol Coordinator: class {
    // MARK: - Variables
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    // MARK: - Functions
    func start()
    func back()
    func add(childCoordinator coordinator: Coordinator)
    func remove(childCoordinator coordinator: Coordinator)
    func childDidFinish(_ child: Coordinator?)
}

// MARK: - Extensions
extension Coordinator {
    func add(childCoordinator coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(childCoordinator coordinator: Coordinator) {
        childCoordinators.removeAll {
            $0 === coordinator
        }
    }
    
    func back() {}
    
    func childDidFinish(_ child: Coordinator?) {
        guard let child = child else { return }
        remove(childCoordinator: child)
    }
}
