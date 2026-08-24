import Foundation

enum RewardType: String, Codable, CaseIterable, Hashable {
    case points
    case miles
    case cashBack

    var displayName: String {
        switch self {
        case .points: return "Points"
        case .miles: return "Miles"
        case .cashBack: return "Cash Back"
        }
    }
}
