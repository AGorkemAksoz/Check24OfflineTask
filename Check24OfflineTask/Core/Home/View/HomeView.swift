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
    @State private var isCurrentlyRefreshing: Bool = false
    @State private var showAllProducts: Bool = true
    @State private var showAvailabelProducts: Bool = false
    let amountToPullBeforeRefreshing: CGFloat = 180
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isCurrentlyRefreshing {
                    ProgressView()
                        .frame(height: UIScreen.main.bounds.height / 8)
                }
                LazyVStack(alignment: .leading) {
                    filterSection
                    homeHeader
                    if showAllProducts {
                        allProductsList
                            .transition(.move(edge: .leading))
                    }
                    
                    if showAvailabelProducts {
                        allAvailabelProductsList
                            .transition(.move(edge: .trailing))
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
            .navigationTitle("Check24")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: - Home View View Components
extension HomeView {
    
    private var filterSection: some View {
        HStack {
            Spacer()
            filterButton(for: .alle)
            Spacer()
            filterButton(for: .verfügbar)
            Spacer()
            filterButton(for: .vorgemerkt)
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .buttonStyle(.plain)
        .background(Color.gray)
        
    }
    
    func filterButton(for option: FilterOptions) -> some View {
        return Button(action: {
            switch option {
            case .alle:
                // "Alle" durumu için yapılacak işlemler
                withAnimation {
                    showAllProducts = true
                }
                print("Alle seçildi")
            case .verfügbar:
                withAnimation {
                    showAllProducts = false
                    showAvailabelProducts = true

                }
                // "Verfügbar" durumu için yapılacak işlemler
                print("Verfügbar seçildi")
            case .vorgemerkt:
                // "Vorgemerkt" durumu için yapılacak işlemler
                print("Vorgemerkt seçildi")
            }
        }) {
            Text(option.rawValue)
        }
    }
    
    private var allProductsList: some View {
        ForEach(viewModel.allProducts ?? [], id: \.id) { product in
            NavigationLink {
                DetailView(product: product)
            } label: {
                ProductRowView(product: product)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var allAvailabelProductsList: some View {
        ForEach(viewModel.allAvailabelProducts ?? [], id: \.id) { product in
            NavigationLink {
                DetailView(product: product)
            } label: {
                ProductRowView(product: product)
            }
            .buttonStyle(.plain)
        }
    }
    
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

enum FilterOptions: String {
    case alle = "Alle"
    case verfügbar = "Verfügbar"
    case vorgemerkt = "Vorgemerkt"
}
