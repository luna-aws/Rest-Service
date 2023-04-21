//
//  NetworkManager.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation

final class NetworkManager {
    func getData(model: @escaping(Issues) -> ()) {
        guard let url = Bundle.main.url(forResource: "Mock", withExtension: "json") else { return }
        do {
            let jsonDecoder = JSONDecoder()
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let decodedData = try jsonDecoder.decode(Issues.self, from: data)
            model(decodedData)
        } catch let error {
            print("Error: \(error)")
        }
    }
}
