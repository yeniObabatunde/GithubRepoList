//
//  BaseCoordinator.swift
//  GithubProfiles
//
//   Created by Sharon Omoyeni Babatunde on 01/01/2025.
//
import Foundation

class BaseCoordinator : Coordinator {
    var childCoordinators : [Coordinator] = []
    var isCompleted: (() -> ())?
    
    func start() {
        fatalError("Children should implement `start`.")
    }
}
