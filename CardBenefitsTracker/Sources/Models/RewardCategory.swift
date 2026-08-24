import Foundation
import SwiftData

@Model
final class RewardCategory {
    var name: String = ""
    var rewardTypeRaw: String = RewardType.points.rawValue
    var multiplier: Double = 1
    var spendingCap: Double?
    var notes: String = ""
    var card: CreditCard?

    init(
        name: String,
        rewardType: RewardType,
        multiplier: Double,
        spendingCap: Double? = nil,
        notes: String = ""
    ) {
        self.name = name
        self.rewardTypeRaw = rewardType.rawValue
        self.multiplier = multiplier
        self.spendingCap = spendingCap
        self.notes = notes
    }

    var rewardType: RewardType {
        get { RewardType(rawValue: rewardTypeRaw) ?? .points }
        set { rewardTypeRaw = newValue.rawValue }
    }

    var rateLabel: String {
        switch rewardType {
        case .cashBack:
            return String(format: "%.1f%% back", multiplier)
        case .points:
            return String(format: "%.0fx points", multiplier)
        case .miles:
            return String(format: "%.0fx miles", multiplier)
        }
    }
}
