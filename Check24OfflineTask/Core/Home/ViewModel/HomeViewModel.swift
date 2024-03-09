//
//  HomeViewModel.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import Combine
import Foundation


final class HomeViewModel: ObservableObject {
    @Published var allProducts: [ProductElement]? = []
    @Published var allAvailabelProducts: [ProductElement]? = []
    @Published var allHeaders: [Header]? = []
    
    private let productService = ProductService(networking: NetworkingManager())
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    func addSubscriber() {
        productService.$allProducts
            .sink { [weak self] returnedArray in
                self?.allProducts = returnedArray.first?.products
            }
            .store(in: &cancellables)
        
        productService.$allProducts
            .sink { [weak self] returnedArray in
                guard let headers = returnedArray.first?.header else { return }
                self?.allHeaders?.append(headers)
            }
            .store(in: &cancellables)
        
        productService.$allProducts
            .map { returnedArray -> [ProductElement]? in
                guard let availabelProducts = returnedArray.first?.products?.filter({ product in
                    product.available == true
                }) else { return nil }
                return availabelProducts
            }
            .sink { [weak self] availabelProducts in
                guard let availabelProducts = availabelProducts else { return }
                self?.allAvailabelProducts = availabelProducts
            }
            .store(in: &cancellables)

            
    }
    
    func refreshData() async {
        // To show that Progress View is working, remove the comment line below.
        // try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        DispatchQueue.main.async {
            self.addSubscriber()
        }
    }

}
