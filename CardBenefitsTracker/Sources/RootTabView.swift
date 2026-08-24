import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            CardListView()
                .tabItem { Label("Cards", systemImage: "creditcard.fill") }

            BestCardView()
                .tabItem { Label("Best Card", systemImage: "star.fill") }

            OverviewView()
                .tabItem { Label("Overview", systemImage: "chart.pie.fill") }
        }
    }
}
