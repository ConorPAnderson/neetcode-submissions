import SwiftUI
import SwiftData

struct BestCardView: View {
    @Query(filter: #Predicate<CreditCard> { $0.isActive }) private var activeCards: [CreditCard]
    @State private var searchText = ""
    @State private var selectedCategory: String?

    private var allCategoryNames: [String] {
        let names = activeCards.flatMap { $0.rewardCategories.map { $0.name } }
        return Array(Set(names)).sorted()
    }

    private var filteredCategoryNames: [String] {
        if searchText.isEmpty { return allCategoryNames }
        return allCategoryNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                if activeCards.isEmpty {
                    ContentUnavailableView(
                        "No Active Cards",
                        systemImage: "star.slash",
                        description: Text("Add a card and its reward categories to see which card wins for each purchase.")
                    )
                } else if allCategoryNames.isEmpty {
                    ContentUnavailableView(
                        "No Reward Categories Yet",
                        systemImage: "star.slash",
                        description: Text("Add reward categories to your cards to compare which one earns the most.")
                    )
                } else {
                    Section("Browse by Category") {
                        ForEach(filteredCategoryNames, id: \.self) { name in
                            Button {
                                selectedCategory = name
                            } label: {
                                HStack {
                                    Text(name)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if let best = bestMatch(for: name) {
                                        Text(best.rateLabel)
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Best Card")
            .searchable(text: $searchText, prompt: "Search categories")
            .navigationDestination(item: $selectedCategory) { name in
                CategoryMatchesView(categoryName: name, cards: activeCards)
            }
        }
    }

    private func bestMatch(for categoryName: String) -> RewardCategory? {
        activeCards
            .flatMap { $0.rewardCategories }
            .filter { $0.name == categoryName }
            .max(by: { $0.multiplier < $1.multiplier })
    }
}
