//
//  ContentView.swift
//  Machine Test
//
//  Created by Alen C James on 16/09/24.
//
import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    @StateObject var viewModel = HomeViewModel() // Use @StateObject only in the parent view
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel) // Pass the viewModel to HomeView
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            Text("Category")
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Category")
                }
            
            Text("Cart")
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }
            
            Text("Offers")
                .tabItem {
                    Image(systemName: "tag.fill")
                    Text("Offers")
                }
            
            Text("Account")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
        }
    }
}

// MARK: - HomeView (Child View)
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                HeaderView()
                
                // Banner Section
                BannerCarousel()
                
                // Show an activity indicator if the data is still being loaded
                if viewModel.apiData.isEmpty {
                    ProgressView("Loading...") // Display a loading spinner
                } else {
                    // Most Popular Section
                    if let mostPopular = viewModel.getMostPopular(), !mostPopular.isEmpty {
                        ProductSectionView(sectionTitle: "Most Popular", products: mostPopular)
                    } else {
                        Text("No Most Popular Products Available")
                    }
                    
                    // Categories Section
                    if let categories = viewModel.getCategories(), !categories.isEmpty {
                        CategoriesSectionView(sectionTitle: "Categories", categories: categories)
                    } else {
                        Text("No Categories Available")
                    }
                    
                    // Featured Products Section
                    if let featured = viewModel.getFeaturedProducts(), !featured.isEmpty {
                        ProductSectionView(sectionTitle: "Featured Products", products: featured)
                    } else {
                        Text("No Featured Products Available")
                    }
                }
                
                // If there was an error, show the error message
                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.bottom, 80)
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - HeaderView (Search bar and cart button)
struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            TextField("Search for products", text: .constant(""))
                .padding(.leading, 20)
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Button(action: {
                // Cart action
            }) {
                Image(systemName: "cart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.green)
    }
}

// MARK: - BannerCarousel
struct BannerCarousel: View {
    var body: some View {
        TabView {
            ForEach(0..<3) { index in
                Image("banner_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            }
        }
        .frame(height: 150)
        .tabViewStyle(PageTabViewStyle())
    }
}

// MARK: - ProductSectionView
struct ProductSectionView: View {
    let sectionTitle: String
    let products: [Contents]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(sectionTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("View All") {
                    // Action for viewing all products
                }
                .foregroundColor(.blue)
            }
            .padding([.leading, .trailing])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products, id: \.title) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.leading)
            }
        }
    }
}

// MARK: - ProductCardView
struct ProductCardView: View {
    let product: Contents

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: product.image_url ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .cornerRadius(8)

            Text(product.title ?? "")
                .font(.subheadline)
                .fontWeight(.bold)

            Text("Sale 65% Off")
                .font(.caption)
                .foregroundColor(.red)

            Text("Price: ৳1000")
                .font(.caption)
        }
        .frame(width: 150)
        .padding()
        .background(Color.yellow)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// MARK: - CategoriesSectionView
struct CategoriesSectionView: View {
    let sectionTitle: String
    let categories: [Contents]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(sectionTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("View All") {
                    // Action for viewing all categories
                }
                .foregroundColor(.blue)
            }
            .padding([.leading, .trailing])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories, id: \.title) { category in
                        CategoryCardView(category: category)
                    }
                }
                .padding(.leading)
            }
        }
    }
}

// MARK: - CategoryCardView
struct CategoryCardView: View {
    let category: Contents

    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: URL(string: category.image_url ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            
            Text(category.title ?? "")
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(width: 100)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
#Preview {
    ContentView()
}
