import SwiftUI

struct ExplorerView: View {
    @State private var searchText = ""
    @State private var selectedCategory = 0
    let categories = ["All", "Crypto", "Sports", "Tech", "Politics"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DareColor.secondaryText)
                    TextField("Search markets...", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding()
                .background(DareColor.surface)
                .cornerRadius(12)
                .padding()
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            CategoryButton(
                                title: categories[index],
                                isSelected: selectedCategory == index,
                                action: { selectedCategory = index }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Market List
                List {
                    ForEach(mockMarkets) { market in
                        MarketRow(market: market)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
            .background(DareColor.obsidian.ignoresSafeArea())
            .navigationTitle("Explorer")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DareTypography.caption.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? DareColor.neonCyan : DareColor.surface)
                .foregroundColor(isSelected ? .black : .white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(DareColor.neonCyan.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
                )
        }
    }
}

struct MarketRow: View {
    let market: Market
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(market.color.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(market.color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(market.title)
                    .font(DareTypography.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("\(market.category) • \(market.volume) vol")
                    .font(DareTypography.caption)
                    .foregroundColor(DareColor.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(market.chance)%")
                    .font(DareTypography.headline)
                    .foregroundColor(DareColor.neonCyan)
                Text("Chance")
                    .font(DareTypography.caption)
                    .foregroundColor(DareColor.secondaryText)
            }
        }
        .padding()
        .glassStyle()
    }
}

#Preview {
    ExplorerView()
}
