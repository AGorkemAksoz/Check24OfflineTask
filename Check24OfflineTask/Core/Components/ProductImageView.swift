//
//  ProductImageView.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import SwiftUI

struct ProductImageView: View {
    let product: ProductElement
    var body: some View {
        AsyncImage(url: URL(string: product.imageURL!)) { image in
            image
                .resizable()
                .frame(width: 80, height: 80)
        } placeholder: {
            ProgressView()
        }
        .background(Color(hex: product.colorCode?.rawValue ?? "FFF"))
    }
}
