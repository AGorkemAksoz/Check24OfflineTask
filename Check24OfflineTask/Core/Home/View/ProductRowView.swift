//
//  ProductRowView.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import SwiftUI

struct ProductRowView: View {
    let product: ProductElement
    
    private var isAvailable: Bool {
        guard let isAvailabe = product.available else { return false}
        return isAvailabe
    }
    
    
    var body: some View {
        HStack {
            if isAvailable {
                ProductImageView(product: product)
                bodyOfRow
            } else {
                bodyOfRow
                ProductImageView(product: product)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(style: StrokeStyle(lineWidth: 1))
        )
    }
}

//struct ProductRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductRowView()
//    }
//}

extension ProductRowView {
    private var bodyOfRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(product.name ?? "Unknown Product Name")
                    .font(.headline)
                Spacer()
                if isAvailable {
                    Text(Date(productDateString: product.releaseDate).asShortDatestring())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Text(product.description ?? "Unknown Product Description")
                .font(.subheadline)
                .lineLimit(2)
                .foregroundColor(.gray)
            
            if isAvailable {
                HStack(spacing: 2) {
                    Text("Preis: " + String(product.price?.value ?? 0))
                    Text(product.price?.currency ?? "N/A")
                    Spacer()
                    StarRatingView(rating: product.rating ?? 0)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            } else {
                StarRatingView(rating: product.rating ?? 0)
                    
            }
        }
    }
}
