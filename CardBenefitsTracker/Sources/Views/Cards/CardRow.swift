import SwiftUI

struct CardRow: View {
    let card: CreditCard

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: card.colorHex))
                .frame(width: 44, height: 30)
                .overlay(
                    Image(systemName: "wave.3.right")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.85))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(card.name)
                    .font(.headline)
                Text(card.last4.isEmpty ? card.issuer : "\(card.issuer) •••• \(card.last4)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(card.annualFee, format: .currency(code: "USD"))
                    .font(.subheadline)
                Text(renewalLabel)
                    .font(.caption2)
                    .foregroundStyle(card.daysUntilRenewal <= 30 ? .orange : .secondary)
            }
        }
        .padding(.vertical, 4)
        .opacity(card.isActive ? 1 : 0.5)
    }

    private var renewalLabel: String {
        if card.daysUntilRenewal <= 30 {
            return "Renews in \(card.daysUntilRenewal)d"
        }
        return "Renews \(card.nextRenewalDate.formatted(.dateTime.month(.abbreviated).day()))"
    }
}
