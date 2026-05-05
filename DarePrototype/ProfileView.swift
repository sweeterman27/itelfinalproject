import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [DareColor.neonCyan, DareColor.neonPink], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 100, height: 100)
                            
                            Text("JD")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("John Dare")
                                .font(DareTypography.largeTitle)
                                .foregroundColor(.white)
                            Text("@johndare • Pro Tier")
                                .font(DareTypography.caption)
                                .foregroundColor(DareColor.secondaryText)
                        }
                    }
                    .padding(.vertical, 32)
                    
                    // Badges Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Achievements")
                            .font(DareTypography.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            BadgeIcon(icon: "crown.fill", color: .yellow)
                            BadgeIcon(icon: "bolt.fill", color: DareColor.neonCyan)
                            BadgeIcon(icon: "shield.fill", color: .blue)
                            BadgeIcon(icon: "star.fill", color: DareColor.neonPink)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Settings List
                    VStack(spacing: 1) {
                        ProfileRow(icon: "person.fill", title: "Account Settings")
                        ProfileRow(icon: "shield.checkerboard", title: "Security")
                        ProfileRow(icon: "bell.fill", title: "Notifications")
                        ProfileRow(icon: "creditcard.fill", title: "Banking")
                        ProfileRow(icon: "questionmark.circle.fill", title: "Support")
                    }
                    .background(DareColor.surface)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Button(action: {}) {
                        Text("Sign Out")
                            .font(DareTypography.headline)
                            .foregroundColor(DareColor.neonPink)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .glassStyle()
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
                .padding(.bottom, 32)
            }
            .background(DareColor.obsidian.ignoresSafeArea())
            .navigationTitle("Profile")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct BadgeIcon: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Circle()
            .fill(DareColor.surface)
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            )
            .overlay(
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(DareColor.neonCyan)
                .frame(width: 24)
            
            Text(title)
                .font(DareTypography.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(DareColor.secondaryText)
        }
        .padding()
        .background(DareColor.surface)
    }
}

#Preview {
    ProfileView()
}
