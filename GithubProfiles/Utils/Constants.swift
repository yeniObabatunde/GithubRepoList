//
//  Constants.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

enum Constants {
    enum ApiHelper {
        static let baseURL = "https://api.github.com/"
    }
    
    enum Strings {
        static let navigationTitle = "Github Users"
        static let loadData = "LOAD MORE DATA"
        static let emptyData = "No data to show at the moment"
        static let loadingData = "Loading..."
    }
    
    enum Identifier {
        static let loaderCell = "LOADERCELL"
    }
    
    enum Alert {
        static let errorTitle = "Error"
    }
}
