import SwiftUI

// --- DESIGN SYSTEM ---
struct DareTheme {
    static let background = Color(hex: "000000")
    static let accent = Color(hex: "CCFF00") // Cyber Green
    static let cardBg = Color.white.opacity(0.05)
    
    static func glassMaterial() -> some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white.opacity(0.03))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

struct DareItem: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let time: String
}

// MARK: - App Entry
@main
struct DareMarketApp: App {
    var body: some Scene {
        WindowGroup {
            DareMarketAppView()
        }
    }
}

struct DareMarketAppView: View {
    @State private var hasEntered = false
    @State private var isWalletConnected = false
    
    var body: some View {
        ZStack {
            DareTheme.background.ignoresSafeArea()
            
            if !hasEntered {
                SplashView(onEnter: { hasEntered = true })
            } else {
                MainContainerView(isWalletConnected: $isWalletConnected)
            }
        }
    }
}

// MARK: - Splash View
struct SplashView: View {
    var onEnter: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("DARE")
                    .font(.system(size: 72, weight: .black, design: .monospaced))
                    .italic()
                    .foregroundColor(.white)
                
                Text("MARKET")
                    .font(.system(size: 14, weight: .bold))
                    .tracking(8)
                    .foregroundColor(DareTheme.accent)
            }
            .scaleEffect(isAnimating ? 1 : 0.8)
            .opacity(isAnimating ? 1 : 0)
            
            Spacer()
            
            VStack(spacing: 20) {
                Text("Would you dare?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Spacer()
                
                Button(action: onEnter) {
                    Text("ENTER APP")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 18)
                        .background(DareTheme.accent)
                        .clipShape(Capsule())
                        .shadow(color: DareTheme.accent.opacity(0.5), radius: 20, x: 0, y: 10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Main Container
struct MainContainerView: View {
    @Binding var isWalletConnected: Bool
    @State private var selectedTab = 0
    @State private var isShowingPlaceDare = false
    @State private var selectedMarketTitle = ""
    @State private var isShowingWalletModal = false
    
    // Notification State
    @State private var currentNotification: String? = nil
    let timer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DareTheme.background.ignoresSafeArea()
            
            // Content
            Group {
                switch selectedTab {
                case 0: ExploreView(isWalletConnected: isWalletConnected, onTapDare: { title in
                    selectedMarketTitle = title
                    isShowingPlaceDare = true
                }, onConnect: { isShowingWalletModal = true })
                case 1: FeedView()
                case 2: LeaderboardView()
                case 3: ProfileView(isWalletConnected: $isWalletConnected)
                default: EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 90) // Room for TabBar
            
            // Tab Bar
            TabBarView(selectedTab: $selectedTab)
            
            // Notification Overlay
            VStack {
                if let msg = currentNotification {
                    NotificationToast(message: msg)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
            }
            .padding(.top, 60)
            .zIndex(100)
        }
        .sheet(isPresented: $isShowingPlaceDare) {
            PlaceDareModal(title: selectedMarketTitle)
        }
        .sheet(isPresented: $isShowingWalletModal) {
            WalletModal(isConnected: $isWalletConnected)
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                currentNotification = "\(MockData.randomUser()) \(MockData.randomAction())!"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.spring()) {
                    currentNotification = nil
                }
            }
        }
    }
}

// MARK: - Notification Component
struct NotificationToast: View {
    let message: String
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(DareTheme.accent)
                .frame(width: 8, height: 8)
                .shadow(color: DareTheme.accent, radius: 4)
            
            Text(message)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(DareTheme.accent)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.8))
                .overlay(Capsule().stroke(DareTheme.accent.opacity(0.3), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.5), radius: 20, y: 10)
    }
}

// MARK: - Explore View
struct ExploreView: View {
    var isWalletConnected: Bool
    var onTapDare: (String) -> Void
    var onConnect: () -> Void
    
    @Namespace var namespace
    @State private var selectedBento: String? = nil
    @State private var activeCategory = "All"
    let categories = ["All", "Crypto", "Stocks", "Sports", "Politics"]
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    TickerView()
                    
                    // Search Bar & Wallet
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.white.opacity(0.3))
                            TextField("Search markets...", text: .constant(""))
                                .font(.system(size: 14))
                        }
                        .padding(14)
                        .background(DareTheme.glassMaterial())
                        
                        if !isWalletConnected {
                            Button(action: onConnect) {
                                Text("CONNECT")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(DareTheme.accent)
                                    .clipShape(Capsule())
                            }
                        } else {
                            Circle()
                                .fill(DareTheme.accent.opacity(0.1))
                                .frame(width: 45, height: 45)
                                .overlay(Text("👛"))
                        }
                    }
                    .padding(.horizontal, 20)

                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { cat in
                                Text(cat)
                                    .font(.system(size: 12, weight: .bold))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(activeCategory == cat ? DareTheme.accent : Color.white.opacity(0.05))
                                    .foregroundColor(activeCategory == cat ? .black : .white)
                                    .clipShape(Capsule())
                                    .onTapGesture { withAnimation { activeCategory = cat } }
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    // Bento Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        BentoCard(title: "Cyber Market", value: "2.4k Active", color: .blue, isLarge: true, namespace: namespace, id: "cyber")
                            .onTapGesture { withAnimation(.spring()) { selectedBento = "cyber" } }
                        
                        BentoCard(title: "Win Rate", value: "68%", color: DareTheme.accent, isLarge: false, namespace: namespace, id: "winrate")
                            .onTapGesture { withAnimation(.spring()) { selectedBento = "winrate" } }
                        
                        BentoCard(title: "Volume", value: "$1.2M", color: .orange, isLarge: false, namespace: namespace, id: "volume")
                            .onTapGesture { withAnimation(.spring()) { selectedBento = "volume" } }
                        
                        BentoCard(title: "Live Feed", value: "Tap to view", color: .purple, isLarge: true, namespace: namespace, id: "livefeed")
                            .onTapGesture { withAnimation(.spring()) { selectedBento = "livefeed" } }
                    }
                    .padding(.horizontal, 20)
                    
                    // Featured List (Functional)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("\(activeCategory) Dares").font(.system(size: 18, weight: .bold))
                            Spacer()
                            Text("See All").font(.system(size: 12, weight: .bold)).foregroundColor(DareTheme.accent)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(MockData.getDares(for: activeCategory)) { dare in
                                FeatureCard(title: dare.title, category: dare.category, time: dare.time, onTap: { onTapDare(dare.title) })
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
            }
            
            // Detail Overlay
            if let id = selectedBento {
                MarketDetailView(id: id, namespace: namespace, onDismiss: {
                    withAnimation(.spring()) { selectedBento = nil }
                })
            }
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @Binding var isWalletConnected: Bool
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                HeaderView(title: "Profile", subtitle: "Settings")
                
                VStack(spacing: 30) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(Text("👤").font(.system(size: 40)))
                        
                        VStack(spacing: 4) {
                            Text(isWalletConnected ? "0x71C...3A2" : "Guest User")
                                .font(.system(size: 20, weight: .black))
                            Text(isWalletConnected ? "CONNECTED" : "NOT CONNECTED")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(isWalletConnected ? DareTheme.accent : .red)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(30)
                    .background(DareTheme.glassMaterial())
                    
                    if isWalletConnected {
                        // Quick Stats
                        HStack(spacing: 16) {
                            QuickStat(label: "Balance", value: "1.24 ETH")
                            QuickStat(label: "Active Dares", value: "4")
                        }
                        
                        // Feature 7: Portfolio Chart
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Portfolio Growth").font(.system(size: 16, weight: .bold))
                                Spacer()
                                Text("+12.4%").font(.system(size: 14, weight: .bold)).foregroundColor(DareTheme.accent)
                            }
                            PortfolioChartView()
                        }
                        .padding(24)
                        .background(DareTheme.glassMaterial())
                        
                        // Feature 9: Achievement Badges
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Achievements").font(.system(size: 16, weight: .bold))
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                BadgeView(icon: "🌱", name: "Early Adopter", color: DareTheme.accent)
                                BadgeView(icon: "🔥", name: "High Roller", color: .orange)
                                BadgeView(icon: "💎", name: "Diamond Hands", color: .blue)
                            }
                        }
                        .padding(24)
                        .background(DareTheme.glassMaterial())
                    }
                }
            }
            .padding(20)
        }
    }
}

struct PortfolioChartView: View {
    var body: some View {
        VStack(spacing: 8) {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 80))
                path.addCurve(to: CGPoint(x: 100, y: 40), control1: CGPoint(x: 30, y: 70), control2: CGPoint(x: 70, y: 20))
                path.addCurve(to: CGPoint(x: 200, y: 60), control1: CGPoint(x: 130, y: 60), control2: CGPoint(x: 170, y: 80))
                path.addCurve(to: CGPoint(x: 300, y: 10), control1: CGPoint(x: 230, y: 40), control2: CGPoint(x: 270, y: -10))
            }
            .stroke(DareTheme.accent, lineWidth: 3)
            .frame(height: 100)
            
            HStack {
                Text("MON").font(.system(size: 10))
                Spacer()
                Text("WED").font(.system(size: 10))
                Spacer()
                Text("FRI").font(.system(size: 10))
                Spacer()
                Text("SUN").font(.system(size: 10))
            }
            .foregroundColor(.white.opacity(0.3))
        }
    }
}

struct BadgeView: View {
    let icon: String
    let name: String
    let color: Color
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(color.opacity(0.1))
                    .frame(width: 60, height: 60)
                Text(icon).font(.system(size: 24))
            }
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(color.opacity(0.3), lineWidth: 1))
            
            Text(name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Navigation Components
struct TabBarView: View {
    @Binding var selectedTab: Int
    var body: some View {
        HStack {
            TabButton(icon: "square.grid.2x2.fill", index: 0, selectedTab: $selectedTab)
            TabButton(icon: "bolt.fill", index: 1, selectedTab: $selectedTab)
            TabButton(icon: "trophy.fill", index: 2, selectedTab: $selectedTab)
            TabButton(icon: "person.fill", index: 3, selectedTab: $selectedTab)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 30)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.8))
                .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1))
                .shadow(color: .black, radius: 20)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

struct TabButton: View {
    let icon: String
    let index: Int
    @Binding var selectedTab: Int
    var body: some View {
        Button(action: { withAnimation { selectedTab = index } }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(selectedTab == index ? DareTheme.accent : .white.opacity(0.3))
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Other Views (Helper Components)
struct TickerView: View {
    @State private var offset: CGFloat = 0
    let items = [
        ("BTC", "$98,421", "+2.4%"),
        ("ETH", "$3,241", "-1.2%"),
        ("SOL", "$184", "+5.8%"),
        ("AVAX", "$42", "+0.4%")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0..<10) { _ in
                    ForEach(items, id: \.0) { item in
                        HStack(spacing: 8) {
                            Text(item.0).font(.system(size: 12, weight: .black))
                            Text(item.1).font(.system(size: 12))
                            Text(item.2).font(.system(size: 12, weight: .bold))
                                .foregroundColor(item.2.contains("+") ? DareTheme.accent : .red)
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.03))
        }
    }
}

struct FeatureCard: View {
    let title: String
    let category: String
    let time: String
    let onTap: () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 16, weight: .bold))
                Text("\(category) • Ends in \(time)").font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
            }
            Spacer()
            Button(action: onTap) {
                Text("DARE")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(DareTheme.accent)
                    .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(DareTheme.glassMaterial())
    }
}

// MARK: - Detail View
struct MarketDetailView: View {
    let id: String
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            DareTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(getBrandColor().opacity(0.1))
                        .matchedGeometryEffect(id: "bg-\(id)", in: namespace)
                        .frame(height: 260)
                    
                    VStack(alignment: .leading) {
                        Button(action: onDismiss) {
                            Image(systemName: "chevron.left").font(.title2.bold())
                        }
                        .padding(.top, 60)
                        Spacer()
                        Text(id.uppercased()).font(.system(size: 14, weight: .bold)).foregroundColor(getBrandColor())
                        Text(getDisplayTitle()).font(.system(size: 32, weight: .black))
                    }
                    .padding(24)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        DetailSection(title: "INSIGHTS", content: "Detailed analysis for \(getDisplayTitle()) would go here.")
                        if id == "winrate" { WinRateGraph() }
                        if id == "volume" { VolumeChart() }
                        if id == "livefeed" { MiniFeed() }
                    }
                    .padding(24)
                }
            }
        }
    }
    
    func getBrandColor() -> Color {
        switch id {
        case "cyber": return .blue
        case "winrate": return DareTheme.accent
        case "volume": return .orange
        case "livefeed": return .purple
        default: return .white
        }
    }
    
    func getDisplayTitle() -> String {
        switch id {
        case "cyber": return "Cyber Hub"
        case "winrate": return "Your Alpha"
        case "volume": return "Total Flow"
        case "livefeed": return "Network Pulse"
        default: return "Market"
        }
    }
}

// MARK: - Shared Views
struct HeaderView: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(subtitle).font(.system(size: 14, weight: .bold)).foregroundColor(DareTheme.accent)
            Text(title).font(.system(size: 34, weight: .black))
        }
    }
}

struct QuickStat: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 12)).foregroundColor(.white.opacity(0.4))
            Text(value).font(.system(size: 18, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(DareTheme.glassMaterial())
    }
}

struct BentoCard: View {
    let title: String
    let value: String
    let color: Color
    let isLarge: Bool
    var namespace: Namespace.ID
    let id: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Circle().fill(color.opacity(0.2)).frame(width: 32, height: 32)
            Spacer()
            Text(title).font(.system(size: 14)).foregroundColor(.white.opacity(0.6))
            Text(value).font(.system(size: 18, weight: .bold))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: isLarge ? 180 : 140)
        .background(DareTheme.glassMaterial().matchedGeometryEffect(id: "bg-\(id)", in: namespace))
    }
}

struct WinRateGraph: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<10) { i in
                RoundedRectangle(cornerRadius: 4)
                    .fill(DareTheme.accent.opacity(Double(i+1)/10))
                    .frame(height: CGFloat.random(in: 40...120))
            }
        }
        .padding(20)
        .background(DareTheme.glassMaterial())
    }
}

struct VolumeChart: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(["BTC", "ETH", "SOL"], id: \.self) { coin in
                HStack {
                    Text(coin).font(.caption.bold())
                    Spacer()
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.orange.opacity(0.5))
                        .frame(width: CGFloat.random(in: 100...200), height: 8)
                }
            }
        }
        .padding(20)
        .background(DareTheme.glassMaterial())
    }
}

struct MiniFeed: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<5) { i in
                HStack {
                    Circle().fill(DareTheme.accent).frame(width: 8, height: 8)
                    Text("\(MockData.randomUser()) \(MockData.randomAction())").font(.caption)
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(DareTheme.glassMaterial())
    }
}

struct FeedView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                HeaderView(title: "Feed", subtitle: "Live Activity")
                ForEach(0..<15) { i in
                    FeedItem(user: MockData.usernames[i % MockData.usernames.count], action: MockData.randomAction(), amount: MockData.randomAmount(), time: "\(Int.random(in: 1...59))m ago")
                }
            }
            .padding(20)
        }
    }
}

struct FeedItem: View {
    let user: String; let action: String; let amount: String; let time: String
    var body: some View {
        HStack {
            Circle().fill(Color.white.opacity(0.1)).frame(width: 40, height: 40).overlay(Text(String(user.first ?? "U")))
            VStack(alignment: .leading) {
                Text(user).font(.bold())
                Text("\(action) for \(amount)").font(.caption).foregroundColor(.white.opacity(0.6))
            }
            Spacer()
            Text(time).font(.caption2).opacity(0.4)
        }
        .padding(16).background(DareTheme.glassMaterial())
    }
}

struct LeaderboardView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                HeaderView(title: "Rankings", subtitle: "Top Darers")
                ForEach(0..<10) { i in
                    LeaderboardRow(rank: i+1, name: MockData.usernames[i % MockData.usernames.count], score: "\(10000 - i*500) pts")
                }
            }
            .padding(20)
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int; let name: String; let score: String
    var body: some View {
        HStack {
            Text("\(rank)").bold().foregroundColor(rank <= 3 ? DareTheme.accent : .white.opacity(0.3)).frame(width: 30)
            Text(name).bold()
            Spacer()
            Text(score).foregroundColor(DareTheme.accent)
        }
        .padding(16).background(DareTheme.glassMaterial())
    }
}

struct DetailSection: View {
    let title: String; let content: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption.bold()).foregroundColor(DareTheme.accent)
            Text(content).foregroundColor(.white.opacity(0.7))
        }
    }
}

struct PlaceDareModal: View {
    let title: String
    @Environment(\.dismiss) var dismiss
    @State private var isSuccess = false
    @State private var isLoading = false
    var body: some View {
        ZStack {
            DareTheme.background.ignoresSafeArea()
            if isSuccess {
                SuccessView(onFinish: { dismiss() })
            } else {
                VStack(spacing: 30) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("PLACE YOUR DARE").font(.caption.bold()).foregroundColor(DareTheme.accent)
                            Text(title).font(.title.bold())
                        }
                        Spacer()
                        Button { dismiss() } label: { Image(systemName: "xmark.circle.fill").font(.title) }
                    }
                    Spacer()
                    Button(action: {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { isLoading = false; isSuccess = true }
                    }) {
                        Text(isLoading ? "PROCESSING..." : "CONFIRM DARE")
                            .font(.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(DareTheme.accent)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
                .padding(30)
            }
        }
    }
}

struct SuccessView: View {
    var onFinish: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 80)).foregroundColor(DareTheme.accent)
            Text("DARE PLACED!").font(.title.bold())
            Button("AWESOME", action: onFinish).padding().background(Color.white.opacity(0.1)).clipShape(Capsule())
        }
    }
}

struct WalletModal: View {
    @Binding var isConnected: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            DareTheme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("CONNECT WALLET").font(.bold()).foregroundColor(DareTheme.accent)
                Button("MetaMask") { isConnected = true; dismiss() }.padding().background(DareTheme.glassMaterial())
                Button("Phantom") { isConnected = true; dismiss() }.padding().background(DareTheme.glassMaterial())
                Spacer()
            }
            .padding(30)
        }
    }
}

struct MockData {
    static let usernames = ["DegenDon", "Whale_Watcher", "SolanaSlayer", "AlphaHunter", "EtherGhost", "Luna_Tic", "BullRun_X", "BearKiller", "CryptoVizier", "Zenith_Ops", "Nova_Pulse", "Void_Trader"]
    static let actions = ["placed a dare", "doubled down", "closed position", "entered market"]
    
    static let featuredDares: [String: [DareItem]] = [
        "All": [
            DareItem(title: "BTC to $100k", category: "Crypto", time: "12:45:01"),
            DareItem(title: "Apple to $250", category: "Stocks", time: "05:12:40"),
            DareItem(title: "Lakers vs Celtics", category: "Sports", time: "01:30:15"),
            DareItem(title: "Election 2026", category: "Politics", time: "48:00:00")
        ],
        "Crypto": [
            DareItem(title: "BTC to $100k", category: "Crypto", time: "12:45:01"),
            DareItem(title: "ETH to $5k", category: "Crypto", time: "08:10:22"),
            DareItem(title: "SOL to $250", category: "Crypto", time: "22:15:45")
        ],
        "Stocks": [
            DareItem(title: "Apple to $250", category: "Stocks", time: "05:12:40"),
            DareItem(title: "Tesla Recovery", category: "Stocks", time: "02:44:12"),
            DareItem(title: "NVIDIA Split?", category: "Stocks", time: "14:20:05")
        ],
        "Sports": [
            DareItem(title: "Lakers vs Celtics", category: "Sports", time: "01:30:15"),
            DareItem(title: "Super Bowl MVP", category: "Sports", time: "72:10:00"),
            DareItem(title: "World Cup Finals", category: "Sports", time: "96:00:00")
        ],
        "Politics": [
            DareItem(title: "Election 2026", category: "Politics", time: "48:00:00"),
            DareItem(title: "Policy Change", category: "Politics", time: "120:00:00")
        ]
    ]
    
    static func getDares(for category: String) -> [DareItem] {
        return featuredDares[category] ?? featuredDares["All"]!
    }
    
    static func randomUser() -> String { usernames.randomElement() ?? "User" }
    static func randomAction() -> String { actions.randomElement() ?? "acted" }
    static func randomAmount() -> String { String(format: "%.2f ETH", Double.random(in: 0.1...5.0)) }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
