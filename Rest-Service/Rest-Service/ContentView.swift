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
        if let items = viewModel.issues?.issues {
            List {
                ForEach(items.indices, id: \.self) { index in
                    Text("""
                            Issue Number: \(index)
                            Title: \(items[index].title ?? "NULL")
                            Desc: \(items[index].desc ?? "NULL")
                            Issue ID: \(items[index].issueId ?? "NULL")
                            Issue category: \(items[index].issueCategories?[0].desc ?? "NULL")
                        """)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
