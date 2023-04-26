//
//  AppConstants.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/25/23.
//

import Foundation

enum AppConstants: String {
    case postUrl = "https://jsonplaceholder.typicode.com/posts"
    case otherUrl = "https://www.google.com"
    
    var absoluteURl: URL? {
        return URL(string: self.rawValue)
    }
}
