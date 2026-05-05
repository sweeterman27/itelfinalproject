import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    init() {
        // Setup custom appearance for TabBar
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(DareColor.obsidian.opacity(0.8))
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            ExplorerView()
                .tabItem {
                    Label("Explorer", systemImage: "safari.fill")
                }
                .tag(1)
            
            PortfolioView()
                .tabItem {
                    Label("Portfolio", systemImage: "chart.pie.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(DareColor.neonCyan)
        .background(DareColor.obsidian.ignoresSafeArea())
    }
}

#Preview {
    MainTabView()
}
