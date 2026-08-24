import SwiftUI
import SwiftData

struct AddEditCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var cardToEdit: CreditCard? = nil

    @State private var name = ""
    @State private var issuer = ""
    @State private var network = CardPresets.networks[0]
    @State private var last4 = ""
    @State private var annualFee = ""
    @State private var openedDate = Date()
    @State private var colorHex = CardPresets.colors[0]
    @State private var notes = ""

    private var isEditing: Bool { cardToEdit != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Card Details") {
                    TextField("Card Name (e.g. Sapphire Preferred)", text: $name)
                    TextField("Issuer (e.g. Chase)", text: $issuer)
                    Picker("Network", selection: $network) {
                        ForEach(CardPresets.networks, id: \.self) { Text($0).tag($0) }
                    }
                    TextField("Last 4 Digits", text: $last4)
                        .keyboardType(.numberPad)
                }

                Section("Annual Fee") {
                    TextField("Annual Fee", text: $annualFee)
                        .keyboardType(.decimalPad)
                    DatePicker("Card Opened", selection: $openedDate, displayedComponents: .date)
                }

                Section("Color") {
                    HStack {
                        ForEach(CardPresets.colors, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: colorHex == hex ? 2 : 0)
                                        .padding(-3)
                                )
                                .onTapGesture { colorHex = hex }
                        }
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle(isEditing ? "Edit Card" : "Add Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear(perform: loadIfEditing)
        }
    }

    private func loadIfEditing() {
        guard let card = cardToEdit else { return }
        name = card.name
        issuer = card.issuer
        network = card.network
        last4 = card.last4
        annualFee = card.annualFee == 0 ? "" : String(card.annualFee)
        openedDate = card.openedDate
        colorHex = card.colorHex
        notes = card.notes
    }

    private func save() {
        let fee = Double(annualFee) ?? 0
        if let card = cardToEdit {
            card.name = name
            card.issuer = issuer
            card.network = network
            card.last4 = last4
            card.annualFee = fee
            card.openedDate = openedDate
            card.colorHex = colorHex
            card.notes = notes
        } else {
            let card = CreditCard(
                name: name,
                issuer: issuer,
                network: network,
                last4: last4,
                annualFee: fee,
                openedDate: openedDate,
                colorHex: colorHex,
                notes: notes
            )
            modelContext.insert(card)
        }
        dismiss()
    }
}
