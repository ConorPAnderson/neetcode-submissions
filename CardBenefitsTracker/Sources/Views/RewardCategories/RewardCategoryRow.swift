import SwiftUI

struct RewardCategoryRow: View {
    let category: RewardCategory

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(category.name)
                    .font(.subheadline.weight(.medium))
                if let cap = category.spendingCap {
                    Text("Capped at \(cap.formatted(.currency(code: "USD"))) / yr")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                if !category.notes.isEmpty {
                    Text(category.notes)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(category.rateLabel)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.blue)
        }
        .padding(.vertical, 4)
    }
}
