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
    
    func gettingDataWithScapingClosure(model: @escaping([PostModel]) -> ()) {
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
    
    func gettingDataWithPromise() -> Promise<[PostModel]> {
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
    
    func gettingDataWithFutureAndDataTaskPublisher() -> Future<[PostModel], Error> {
        return Future<[PostModel], Error> { future in
            guard let url = AppConstants.postUrl.absoluteURl else {
                future(.failure(ErrorHelper.urlFailed))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, _ -> [PostModel] in
                    try JSONDecoder().decode([PostModel].self, from: data)
                }
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished: break
                        case .failure(let error): future(.failure(ErrorHelper.serverError(error)))
                    }
                }, receiveValue: { postModel in
                    future(.success(postModel))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func gettingDataWithFutureDataTask() -> Future<[PostModel], Error> {
        return Future<[PostModel], Error> { future in
            guard let url = AppConstants.postUrl.absoluteURl else {
                future(.failure(ErrorHelper.urlFailed))
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error {
                    future(.failure(ErrorHelper.serverError(error)))
                } else if let data {
                    do {
                        let decodedData = try JSONDecoder().decode([PostModel].self, from: data)
                        future(.success(decodedData))
                    } catch {
                        future(.failure(ErrorHelper.decodedError))
                    }
                }
            }
            .resume()
        }
    }
    
    func gettingDataWithAnyPublisher() -> AnyPublisher<[PostModel], Error> {
        guard let url = AppConstants.postUrl.absoluteURl else {
            return Fail(error: ErrorHelper.urlFailed).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .catch { error in
                Fail(error: ErrorHelper.serverError(error))
            }
            .eraseToAnyPublisher()
    }
}
