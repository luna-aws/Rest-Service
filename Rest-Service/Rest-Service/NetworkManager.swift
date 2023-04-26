//
//  NetworkManager.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation
import PromiseKit
import Combine

final class NetworkManager {
    
    private var cancellables = Set<AnyCancellable>()
    
    func getDataWithScapingClosure(model: @escaping([PostModel]) -> ()) {
        guard let url = AppConstants.postUrl.absoluteURl else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { fatalError("data Task Error") }
            
            do {
                let decodedData = try JSONDecoder().decode([PostModel].self, from: data)
                DispatchQueue.main.async {
                    model(decodedData)
                }
            } catch {
                print(ErrorHelper.decodedError)
            }
        }.resume()
    }
    
    func getDataWithPromise() -> Promise<[PostModel]> {
        return Promise<[PostModel]> { promise in
            guard let url = AppConstants.postUrl.absoluteURl else {
                promise.reject(ErrorHelper.urlFailed)
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    promise.reject(ErrorHelper.serverError(error))
                } else if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([PostModel].self, from: data)
                        promise.fulfill(decodedData)
                    } catch {
                        promise.reject(ErrorHelper.decodedError)
                    }
                }
            }
            .resume()
        }
    }
    
    func getdataWithFuture() -> Future<[PostModel], Error> {
        return Future<[PostModel], Error> { future in
            guard let url = AppConstants.postUrl.absoluteURl else {
                future(.failure(ErrorHelper.urlFailed))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, _) -> [PostModel] in
                    try JSONDecoder().decode([PostModel].self, from: data)
                }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        future(.failure(ErrorHelper.serverError(error)))
                    }
                }, receiveValue: { value in
                    future(.success(value))
                })
                .store(in: &self.cancellables)
        }
    }
}
