//
//  NetworkManager.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation
import PromiseKit
import Combine
import VCR

final class NetworkManager {
    
    private var cancellables = Set<AnyCancellable>()
    
    private func getFileURL(with name: String, withExtension ext: String) -> URL? {
        guard let url = ProcessInfo.processInfo.environment["VCR_DIR"] else { return nil }
        return URL(fileURLWithPath: url).appendingPathComponent(name).appendingPathExtension(ext)
    }
    
    func fetchRemoteData<T: Decodable>(from url: URL?, model: T.Type) -> Promise<T>{
        return Promise<T> { promise in
            
            let vcrSession = VCRSession()
            vcrSession.insertTape("Post", record: true)
            
            guard let url else { return promise.reject(ErrorHelper.urlFailed) }
            vcrSession.dataTaskPublisher(for: url)
                .tryMap { data, _ -> T in
                    try JSONDecoder().decode(model, from: data)
                }
                .sink { completion in
                    switch completion {
                    case .failure(_): promise.reject(ErrorHelper.decodedError)
                    case .finished: break
                    }
                } receiveValue: { model in
                    promise.fulfill(model)
                }
                .store(in: &cancellables)
        }
    }
    
    func fetchLocalData<T: Decodable>(with model: T.Type) -> Promise<T> {
        return Promise<T> { promise in
            guard let fileURL = getFileURL(with: "Post", withExtension: "json") else {
                return promise.reject(ErrorHelper.urlFailed)
            }
            do {
                let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                let decodedData = try JSONDecoder().decode(model, from: data)
                promise.fulfill(decodedData)
            } catch {
                promise.reject(ErrorHelper.localError(error))
            }
        }
    }
}
