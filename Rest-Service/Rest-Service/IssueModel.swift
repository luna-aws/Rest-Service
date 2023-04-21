//
//  Model.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation

struct Issues: Decodable {
    let issues: [IssueModel]
}

struct IssueModel: Decodable {
    let createdDate: String?
    let desc: String?
    let issueCategories: [IssueCategory]?
    let issueId: String?
    let issueStatus: String?
    let modifiedDate: String?
    let plans: [Plan]?
    let teams: [Team]?
    let title: String?
    let createdBy: CreatedBy?
}

struct IssueCategory: Decodable {
    let id: Int
    let desc: String
    let name: String?
    let value: String?
    let values: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case desc
        case name
        case value
        case values
        case type
    }
}

struct Plan: Decodable {
    let id: Int
    let desc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case desc
    }
}

struct Team: Decodable {
    let id: Int
    let desc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case desc
    }
}

struct CreatedBy: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
