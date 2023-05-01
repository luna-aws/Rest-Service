//
//  Model.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation

/// Remote fetch
typealias PostData = [Post]

/// Local fetch
struct Posts: Decodable {
    let data: [Post]
}

/// Root model
struct Post: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
