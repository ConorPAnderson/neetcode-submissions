import Foundation
import SwiftData

@Model
final class Benefit {
    var title: String = ""
    var detail: String = ""
    var value: Double = 0
    var frequencyRaw: String = BenefitFrequency.annual.rawValue
    var category: String = "Other"
    var lastUsedPeriodKey: String?
    var card: CreditCard?

    init(
        title: String,
        detail: String,
        value: Double,
        frequency: BenefitFrequency,
        category: String
    ) {
        self.title = title
        self.detail = detail
        self.value = value
        self.frequencyRaw = frequency.rawValue
        self.category = category
    }

    var frequency: BenefitFrequency {
        get { BenefitFrequency(rawValue: frequencyRaw) ?? .annual }
        set { frequencyRaw = newValue.rawValue }
    }

    var currentPeriodKey: String {
        PeriodKey.current(for: frequency, anchor: card?.openedDate ?? Date())
    }

    var isUsedThisPeriod: Bool {
        lastUsedPeriodKey == currentPeriodKey
    }

    func markUsed() {
        lastUsedPeriodKey = currentPeriodKey
    }

    func markUnused() {
        lastUsedPeriodKey = nil
    }
}
