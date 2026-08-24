import SwiftUI
import SwiftData

struct OverviewView: View {
    @Query private var cards: [CreditCard]

    private var activeCards: [CreditCard] { cards.filter { $0.isActive } }

    private var totalAnnualFees: Double {
        activeCards.reduce(0) { $0 + $1.annualFee }
    }

    private var totalBenefitValue: Double {
        activeCards.flatMap { $0.benefits }.reduce(0) { $0 + $1.value }
    }

    private var usedBenefitValue: Double {
        activeCards.flatMap { $0.benefits }.filter { $0.isUsedThisPeriod }.reduce(0) { $0 + $1.value }
    }

    private var upcomingRenewals: [CreditCard] {
        activeCards
            .filter { $0.daysUntilRenewal <= 45 }
            .sorted { $0.daysUntilRenewal < $1.daysUntilRenewal }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Totals") {
                    StatRow(title: "Active Cards", value: "\(activeCards.count)")
                    StatRow(title: "Total Annual Fees", value: totalAnnualFees.formatted(.currency(code: "USD")))
                    StatRow(title: "Tracked Benefit Value", value: totalBenefitValue.formatted(.currency(code: "USD")))
                    StatRow(title: "Benefits Used", value: usedBenefitValue.formatted(.currency(code: "USD")))
                }

                if totalAnnualFees > 0 {
                    Section("Value Check") {
                        let net = usedBenefitValue - totalAnnualFees
                        HStack {
                            Text(net >= 0 ? "You're ahead by" : "You're behind by")
                            Spacer()
                            Text(abs(net).formatted(.currency(code: "USD")))
                                .fontWeight(.semibold)
                                .foregroundStyle(net >= 0 ? .green : .red)
                        }
                        Text("Based on benefits you've marked as used this period versus your total annual fees.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if !upcomingRenewals.isEmpty {
                    Section("Upcoming Renewals") {
                        ForEach(upcomingRenewals) { card in
                            HStack {
                                Text(card.name)
                                Spacer()
                                Text(card.daysUntilRenewal == 0 ? "Today" : "\(card.daysUntilRenewal) days")
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                }

                if !activeCards.isEmpty {
                    Section("Per-Card Breakdown") {
                        ForEach(activeCards) { card in
                            let used = card.benefits.filter { $0.isUsedThisPeriod }.count
                            VStack(alignment: .leading, spacing: 4) {
                                Text(card.name).font(.subheadline.weight(.medium))
                                Text("\(used)/\(card.benefits.count) benefits used this period")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Overview")
        }
    }
}

private struct StatRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).fontWeight(.medium)
        }
    }
}
