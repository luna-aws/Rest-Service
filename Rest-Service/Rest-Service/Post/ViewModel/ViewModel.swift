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
    
    @Published var model: PostData? {
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        getData()
    }
    
    private func getData() {
        networkManager.fetchRemoteData(from: AppConstants.postUrl.absoluteURl, model: PostData.self)
            .done { model in
                DispatchQueue.main.async {
                    print("Getting remote data...")
                    self.model = model
                }
            }.catch { error in
                print("Remote error: \(ErrorHelper.serverError(error))")
                self.networkManager.fetchLocalData(with: Posts.self)
                    .done { posts in
                        print("Getting local Data")
                        self.model = posts.data
                    }.catch { error in
                        print("Local Error: \(ErrorHelper.serverError(error))")
                    }
            }
    }
}
