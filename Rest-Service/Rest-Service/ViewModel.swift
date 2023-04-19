//
//  ViewModel.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Combine

final class ViewModel: ObservableObject {
    
    let didChange = PassthroughSubject<ViewModel, Never>()
    
    @Published var postModel = [PostModel]() {
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        getModel()
    }
    
    private func getModel() {
        NetworkManager().getData {
            self.postModel = $0
        }
    }
}
