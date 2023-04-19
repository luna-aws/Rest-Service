//
//  ContentView.swift
//  Rest-Service
//
//  Created by Rexmoon on 4/18/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List(viewModel.postModel) { model in
            Text(model.title)
                .foregroundColor(.blue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
