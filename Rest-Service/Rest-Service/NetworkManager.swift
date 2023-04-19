//
//  NetworkManager.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation

final class NetworkManager {
    func getData(model: @escaping([PostModel]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { fatalError("URL Error") }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { fatalError("data Task Error") }
            
            do {
                let decodedData = try JSONDecoder().decode([PostModel].self, from: data)
                DispatchQueue.main.async {
                    model(decodedData)
                }
            } catch let error {
                fatalError("Decode error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
