import Foundation
import SwiftData

@Model
final class CreditCard {
    var name: String = ""
    var issuer: String = ""
    var network: String = "Visa"
    var last4: String = ""
    var annualFee: Double = 0
    var openedDate: Date = Date()
    var colorHex: String = "#1D4ED8"
    var notes: String = ""
    var isActive: Bool = true
    var sortOrder: Int = 0

    @Relationship(deleteRule: .cascade, inverse: \Benefit.card)
    var benefits: [Benefit] = []

    @Relationship(deleteRule: .cascade, inverse: \RewardCategory.card)
    var rewardCategories: [RewardCategory] = []

    init(
        name: String,
        issuer: String,
        network: String,
        last4: String,
        annualFee: Double,
        openedDate: Date,
        colorHex: String,
        notes: String = ""
    ) {
        self.name = name
        self.issuer = issuer
        self.network = network
        self.last4 = last4
        self.annualFee = annualFee
        self.openedDate = openedDate
        self.colorHex = colorHex
        self.notes = notes
    }
}

extension CreditCard {
    var nextRenewalDate: Date {
        let calendar = Calendar.current
        let now = Date()
        let opened = calendar.dateComponents([.month, .day], from: openedDate)

        var candidateComponents = calendar.dateComponents([.year], from: now)
        candidateComponents.month = opened.month
        candidateComponents.day = opened.day

        guard let candidate = calendar.date(from: candidateComponents) else {
            return openedDate
        }

        if candidate >= calendar.startOfDay(for: now) {
            return candidate
        }
        return calendar.date(byAdding: .year, value: 1, to: candidate) ?? candidate
    }

    var daysUntilRenewal: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.startOfDay(for: nextRenewalDate)
        return calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
}
