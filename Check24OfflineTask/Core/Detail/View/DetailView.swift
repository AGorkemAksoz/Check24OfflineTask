//
//  DetailView.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel = DetailViewModel()
    
    let product: ProductElement
    
    var buttonTittle: String {
        viewModel.isFavorited ? "Nachdem" : "Vormerken"
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        ProductImageView(product: product)
                        detailTopBar
                    }
                    detailViewBody
                    Spacer()
                }
                .padding()
            }
            footer
        }
        .navigationTitle("Product Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DetailView {
    private var detailTopBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.name ?? "Unknown Product Name")
                .font(.headline)
            
            HStack {
                Text("Preis:")
                Text(String(product.price?.value ?? 0))
                    .foregroundColor(.gray)
                Text(product.price?.currency ?? "N/A")
                    .foregroundColor(.gray)
            }
            
            HStack {
                StarRatingView(rating: product.rating ?? 0)
                Spacer()
                Text(Date(productDateString: product.releaseDate).asShortDatestring())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var detailViewBody: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(product.description ?? "Unknown Description")
                .foregroundColor(.gray)
            
            Button {
                withAnimation {
                    viewModel.isFavorited.toggle()
                }
            } label: {
                Text(buttonTittle)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.blue)
                    )
            }
            
            Text("Beschreibung")
                .font(.headline)
            
            Text(product.longDescription ?? "Unknwon Long Description")
                .foregroundColor(.gray)
        }
    }
    
    private var footer: some View {
        NavigationLink {
            
            WebView(urlString: "https://m.check24.de/rechtliche-hinweise/?deviceoutput=app")
                .edgesIgnoringSafeArea(.all)
        } label: {
            Text("© 2024 Check24")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}
