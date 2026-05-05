import SwiftUI

struct PortfolioView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Balance Summary
                    VStack(spacing: 16) {
                        Text("Total Balance")
                            .font(DareTypography.caption)
                            .foregroundColor(DareColor.secondaryText)
                        
                        Text("$12,840.50")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.right")
                            Text("+$1,240 (12.4%)")
                        }
                        .font(DareTypography.caption.bold())
                        .foregroundColor(DareColor.neonCyan)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(DareColor.neonCyan.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .glassStyle()
                    .padding(.horizontal)
                    
                    // Chart Placeholder
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Performance")
                            .font(DareTypography.headline)
                            .foregroundColor(.white)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(DareColor.surface)
                                .frame(height: 180)
                            
                            // Mock Line Chart
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 140))
                                path.addCurve(to: CGPoint(x: 350, y: 40), 
                                             control1: CGPoint(x: 100, y: 160), 
                                             control2: CGPoint(x: 250, y: 20))
                            }
                            .stroke(DareColor.neonCyan, lineWidth: 3)
                            .shadow(color: DareColor.neonCyan.opacity(0.5), radius: 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Positions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Positions")
                            .font(DareTypography.headline)
                            .foregroundColor(.white)
                        
                        ForEach(mockMarkets.prefix(2)) { market in
                            PositionRow(market: market)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(DareColor.obsidian.ignoresSafeArea())
            .navigationTitle("Portfolio")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct PositionRow: View {
    let market: Market
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(market.title)
                    .font(DareTypography.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text("1,000 Contracts • Yes")
                    .font(DareTypography.caption)
                    .foregroundColor(DareColor.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$840.00")
                    .font(DareTypography.headline)
                    .foregroundColor(.white)
                Text("+$120.00")
                    .font(DareTypography.caption)
                    .foregroundColor(DareColor.neonCyan)
            }
        }
        .padding()
        .glassStyle()
    }
}

#Preview {
    PortfolioView()
}
