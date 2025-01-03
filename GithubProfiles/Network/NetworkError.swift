//
//  NetworkError.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case error(statusCode: Int, data: Data?)
    case invalidData
}

