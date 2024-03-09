//
//  ContentView.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    private var service: ProductService = ProductService(networking: NetworkingManager())
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .onAppear {
            service.getProducts()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
