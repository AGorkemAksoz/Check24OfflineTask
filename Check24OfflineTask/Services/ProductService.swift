//
//  ProductService.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import Combine
import Foundation

final class ProductService {
    private let networking: NetworkingManager
    
    @Published var allProducts:[Product] = []
    var productSubscription: AnyCancellable?
    
    init(networking: NetworkingManager) {
        self.networking = networking
        getProducts()
    }
    
    func getProducts() {
        
        guard let url = URL(string: "http://app.check24.de/products-test.json") else { return }
        
        productSubscription = networking.download(url: url)
            .decode(type: Product.self, decoder: JSONDecoder())
            .sink(receiveCompletion: networking.handleCompletion,
                  receiveValue: { [weak self] returnProduct in
                self?.allProducts.append(returnProduct)
                print(self?.allProducts)
                self?.productSubscription?.cancel()
            })
    }
}
