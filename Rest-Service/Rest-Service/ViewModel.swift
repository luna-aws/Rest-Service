//
//  ViewModel.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import Combine

final class ViewModel: ObservableObject {
    
    let didChange = PassthroughSubject<ViewModel, Never>()
    
    var issues: Issues? {
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        getModel()
    }
    
    private func getModel() {
        NetworkManager().getData {
            self.issues = $0
        }
    }
}
