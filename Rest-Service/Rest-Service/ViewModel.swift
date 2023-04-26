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
        getModelFromFuture()
    }
    
    private func getModel() {
        NetworkManager().getDataWithScapingClosure {
            self.postModel = $0
        }
    }
    
    private func getModelFromPromise() {
        NetworkManager().getDataWithPromise().done { postModel in
            self.postModel = postModel
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func getModelFromFuture() {
        networkManager.getdataWithFuture()
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
