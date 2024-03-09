//
//  HomeView.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.refresh) private var refresh
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    @State private var isCurrentlyRefreshing = false
    let amountToPullBeforeRefreshing: CGFloat = 180
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isCurrentlyRefreshing {
                    ProgressView()
                        .frame(height: UIScreen.main.bounds.height / 8)
                }
                LazyVStack(alignment: .leading) {
                    homeHeader
                    ForEach(viewModel.allProducts ?? [], id: \.id) { product in
                        ProductRowView(product: product)
                    }
                    footer
                }
                .padding()
                .overlay(GeometryReader { geo in
                    let currentScrollViewPosition = -geo.frame(in: .global).origin.y
                    
                    if currentScrollViewPosition < -amountToPullBeforeRefreshing && !isCurrentlyRefreshing {
                        Color.clear.preference(key: ViewOffsetKey.self, value: -geo.frame(in: .global).origin.y)
                    }
                })
            }
            .onPreferenceChange(ViewOffsetKey.self) { scrollPosition in
                if scrollPosition < -amountToPullBeforeRefreshing && !isCurrentlyRefreshing {
                    isCurrentlyRefreshing = true
                    Task {
                        await viewModel.refreshData()
                        await MainActor.run {
                            isCurrentlyRefreshing = false
                        }
                    }
                }
            }
        }
        .navigationTitle("Check24")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: - Home View View Components
extension HomeView {
    private var homeHeader: some View {
        VStack(alignment: .leading) {
            Text(viewModel.allHeaders?.first?.headerTitle ?? "Unknwon Title")
                .font(.headline)
            Text(viewModel.allHeaders?.first?.headerDescription ?? "Unknown Description")
                .font(.subheadline)
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

// MARK: - A preference key to store ScrollView offset
extension HomeView {
    struct ViewOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}
