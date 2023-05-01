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
        if let posts = viewModel.model {
            List(posts) { post in
                Text(post.title)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
