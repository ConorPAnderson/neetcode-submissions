import SwiftUI

struct CategoryMatchesView: View {
    let categoryName: String
    let cards: [CreditCard]

    private var matches: [(card: CreditCard, category: RewardCategory)] {
        cards
            .compactMap { card -> (CreditCard, RewardCategory)? in
                guard let match = card.rewardCategories.first(where: { $0.name == categoryName }) else {
                    return nil
                }
                return (card, match)
            }
            .sorted { $0.1.multiplier > $1.1.multiplier }
    }

    var body: some View {
        List {
            if matches.isEmpty {
                ContentUnavailableView("No Matches", systemImage: "questionmark.circle")
            } else {
                ForEach(Array(matches.enumerated()), id: \.offset) { index, match in
                    HStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: match.card.colorHex))
                            .frame(width: 28, height: 18)

                        VStack(alignment: .leading) {
                            Text(match.card.name)
                                .font(.subheadline.weight(.medium))
                            if let cap = match.category.spendingCap {
                                Text("Capped at \(cap.formatted(.currency(code: "USD"))) / yr")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        Text(match.category.rateLabel)
                            .font(.subheadline.weight(.semibold))

                        if index == 0 {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
