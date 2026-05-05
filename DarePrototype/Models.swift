import SwiftUI

struct Market: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let volume: String
    let chance: Int
    let color: Color
    let imageName: String?
}

struct UserStats {
    let balance: String
    let profit: String
    let rank: String
}

let mockMarkets = [
    Market(title: "Will Bitcoin hit $100k in 2026?", category: "Crypto", volume: "$2.4M", chance: 65, color: .orange, imageName: nil),
    Market(title: "Next SpaceX Starship Launch success?", category: "Tech", volume: "$840K", chance: 82, color: .blue, imageName: nil),
    Market(title: "World Cup 2026 Winner: Argentina?", category: "Sports", volume: "$1.2M", chance: 15, color: .green, imageName: nil),
    Market(title: "AI passes Turing Test by Dec?", category: "Science", volume: "$500K", chance: 45, color: .purple, imageName: nil)
]
