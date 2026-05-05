import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Hero Section
                    ZStack(alignment: .bottomLeading) {
                        Image(uiImage: UIImage(contentsOfFile: "C:/Users/lain/.gemini/antigravity/brain/dec24318-07c0-44ef-bcbc-bbc7b7e90c38/dare_market_hero_1777378749670.png") ?? UIImage())
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                            .frame(height: 220)
                            .clipped()
                            .overlay(
                                LinearGradient(colors: [.clear, DareColor.obsidian], startPoint: .top, endPoint: .bottom)
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("FEATURED MARKET")
                                .font(DareTypography.caption)
                                .foregroundColor(DareColor.neonCyan)
                                .kerning(2)
                            
                            Text("US Election 2026: House Majority")
                                .font(DareTypography.largeTitle)
                                .foregroundColor(.white)
                        }
                        .padding(20)
                    }
                    .glassStyle()
                    .padding(.horizontal)
                    
                    // Trending Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trending Dares")
                            .font(DareTypography.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(mockMarkets) { market in
                                    MarketCard(market: market)
                                        .frame(width: 280)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Stats Section
                    HStack(spacing: 16) {
                        StatBox(title: "Global Vol", value: "$4.2B", icon: "chart.line.uptrend.xyaxis")
                        StatBox(title: "Active Dares", value: "128K", icon: "flame.fill")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(DareColor.obsidian.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("DARE")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(DareColor.neonCyan)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct MarketCard: View {
    let market: Market
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(market.category)
                    .font(DareTypography.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(market.color.opacity(0.2))
                    .foregroundColor(market.color)
                    .cornerRadius(4)
                
                Spacer()
                
                Text(market.volume)
                    .font(DareTypography.caption)
                    .foregroundColor(DareColor.secondaryText)
            }
            
            Text(market.title)
                .font(DareTypography.headline)
                .foregroundColor(.white)
                .lineLimit(2)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(market.chance)%")
                        .font(.title3.bold())
                        .foregroundColor(DareColor.neonCyan)
                    Text("Chance")
                        .font(DareTypography.caption)
                        .foregroundColor(DareColor.secondaryText)
                }
                
                Spacer()
                
                Button("Bet Now") {
                    // Action
                }
                .font(DareTypography.caption.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(DareColor.neonCyan)
                .foregroundColor(.black)
                .cornerRadius(20)
            }
        }
        .padding()
        .glassStyle()
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(DareColor.neonCyan)
            VStack(alignment: .leading) {
                Text(title)
                    .font(DareTypography.caption)
                    .foregroundColor(DareColor.secondaryText)
                Text(value)
                    .font(DareTypography.headline)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .glassStyle()
    }
}

#Preview {
    HomeView()
}
