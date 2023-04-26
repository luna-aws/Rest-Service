//
//  ViewModel.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Foundation
import Combine
import PromiseKit

final class ViewModel: ObservableObject {
    
    private let didChange = PassthroughSubject<ViewModel, Never>()
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var postModel = [PostModel]() {
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        getModelWithFuture()
    }
    
    private func getModelWithScapingClosure() {
        NetworkManager().gettingDataWithScapingClosure { postModel in
            self.postModel = postModel
        }
    }
    
    private func getModelWithPromise() {
        NetworkManager().gettingDataWithPromise()
            .done { postModel in
                self.postModel = postModel
            }.catch { error in
                print(error.localizedDescription)
            }
    }
    
    private func getModelWithFuture() {
        /// To get data from publishers
        networkManager.gettingDataWithFutureDataTask()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .failure(let error): print(ErrorHelper.serverError(error))
                    case .finished: break
                }
            } receiveValue: { postModel in
                self.postModel = postModel
            }
            .store(in: &cancellables)
    }
}
