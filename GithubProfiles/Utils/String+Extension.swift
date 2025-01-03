//
//  String+Extension.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

extension String {
    var asURL: URL? {
        return URL(string: self)
    }
}
