//
//  Error+Helper.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/25/23.
//

import Foundation

enum ErrorHelper: Error {
    case urlFailed
    case decodedError
    case serverError(Error)
}

extension ErrorHelper: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .urlFailed: return NSLocalizedString("Failed to create url", comment: "Error message")
            case .decodedError: return NSLocalizedString("Failed to decode data", comment: "Error message")
        case .serverError(let error): return error.localizedDescription
        }
    }
}

struct ErrorHandler {
    static func handle(_ error: Error) {
        if let error = error as? ErrorHelper {
            print("Error: \(error.localizedDescription)")
        } else {
            print("Error: \(error.localizedDescription)")
        }
    }
}
