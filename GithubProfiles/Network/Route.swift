//
//  Route.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

enum Route {
    case repository
    
    var description: String {
        switch self {
        case .repository:
            return "repositories"
        }
    }
}
