import SwiftUI

struct BenefitRow: View {
    @Bindable var benefit: Benefit

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                withAnimation { toggleUsed() }
            } label: {
                Image(systemName: benefit.isUsedThisPeriod ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(benefit.isUsedThisPeriod ? Color.green : Color.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {
                Text(benefit.title)
                    .font(.subheadline.weight(.medium))
                    .strikethrough(benefit.isUsedThisPeriod)
                if !benefit.detail.isEmpty {
                    Text(benefit.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 6) {
                    Text(benefit.category)
                    Text("•")
                    Text(benefit.frequency.displayName)
                }
                .font(.caption2)
                .foregroundStyle(.tertiary)
            }

            Spacer()

            Text(benefit.value, format: .currency(code: "USD"))
                .font(.subheadline.weight(.semibold))
        }
        .padding(.vertical, 4)
    }

    private func toggleUsed() {
        if benefit.isUsedThisPeriod {
            benefit.markUnused()
        } else {
            benefit.markUsed()
        }
    }
}
