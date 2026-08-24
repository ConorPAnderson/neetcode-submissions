import SwiftUI
import SwiftData

@main
struct CardBenefitsTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [CreditCard.self, Benefit.self, RewardCategory.self])
    }
}
