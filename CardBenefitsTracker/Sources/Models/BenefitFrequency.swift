import Foundation

enum BenefitFrequency: String, Codable, CaseIterable, Identifiable, Hashable {
    case monthly
    case quarterly
    case semiAnnual
    case annual
    case oneTime

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .monthly: return "Monthly"
        case .quarterly: return "Quarterly"
        case .semiAnnual: return "Every 6 Months"
        case .annual: return "Annual"
        case .oneTime: return "One-Time"
        }
    }
}

enum PeriodKey {
    static func current(for frequency: BenefitFrequency, anchor: Date, now: Date = Date()) -> String {
        let calendar = Calendar.current

        switch frequency {
        case .monthly:
            let components = calendar.dateComponents([.year, .month], from: now)
            return "M-\(components.year ?? 0)-\(components.month ?? 0)"

        case .quarterly:
            let components = calendar.dateComponents([.year, .month], from: now)
            let month = components.month ?? 1
            let quarter = ((month - 1) / 3) + 1
            return "Q-\(components.year ?? 0)-\(quarter)"

        case .semiAnnual:
            let components = calendar.dateComponents([.year, .month], from: now)
            let month = components.month ?? 1
            let half = month <= 6 ? 1 : 2
            return "H-\(components.year ?? 0)-\(half)"

        case .annual:
            let anchorMonth = calendar.component(.month, from: anchor)
            let nowComponents = calendar.dateComponents([.year, .month], from: now)
            var cardYear = nowComponents.year ?? 0
            if (nowComponents.month ?? 1) < anchorMonth {
                cardYear -= 1
            }
            return "Y-\(cardYear)"

        case .oneTime:
            return "ONE-TIME"
        }
    }
}
