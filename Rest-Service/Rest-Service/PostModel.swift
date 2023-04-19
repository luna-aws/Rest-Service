//
//  Model.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation

struct PostModel: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let body: String
}
