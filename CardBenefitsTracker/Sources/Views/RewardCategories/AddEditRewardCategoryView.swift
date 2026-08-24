import SwiftUI
import SwiftData

struct AddEditRewardCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let card: CreditCard
    var categoryToEdit: RewardCategory? = nil

    @State private var name = CardPresets.rewardCategoryNames[0]
    @State private var rewardType: RewardType = .points
    @State private var multiplier = ""
    @State private var hasCap = false
    @State private var spendingCap = ""
    @State private var notes = ""

    private var isEditing: Bool { categoryToEdit != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Spending Category", selection: $name) {
                        ForEach(CardPresets.rewardCategoryNames, id: \.self) { Text($0).tag($0) }
                    }
                }
                Section("Reward Rate") {
                    Picker("Type", selection: $rewardType) {
                        Text("Points").tag(RewardType.points)
                        Text("Miles").tag(RewardType.miles)
                        Text("Cash Back").tag(RewardType.cashBack)
                    }
                    .pickerStyle(.segmented)
                    TextField(rewardType == .cashBack ? "Percent back (e.g. 3)" : "Multiplier (e.g. 4)", text: $multiplier)
                        .keyboardType(.decimalPad)
                }
                Section("Annual Cap") {
                    Toggle("This category has a spending cap", isOn: $hasCap)
                    if hasCap {
                        TextField("Cap amount ($)", text: $spendingCap)
                            .keyboardType(.decimalPad)
                    }
                }
                Section("Notes") {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle(isEditing ? "Edit Category" : "Add Reward Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(multiplier.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear(perform: loadIfEditing)
        }
    }

    private func loadIfEditing() {
        guard let category = categoryToEdit else { return }
        name = category.name
        rewardType = category.rewardType
        multiplier = String(category.multiplier)
        if let cap = category.spendingCap {
            hasCap = true
            spendingCap = String(cap)
        }
        notes = category.notes
    }

    private func save() {
        let rate = Double(multiplier) ?? 0
        let cap = hasCap ? Double(spendingCap) : nil
        if let category = categoryToEdit {
            category.name = name
            category.rewardType = rewardType
            category.multiplier = rate
            category.spendingCap = cap
            category.notes = notes
        } else {
            let category = RewardCategory(
                name: name,
                rewardType: rewardType,
                multiplier: rate,
                spendingCap: cap,
                notes: notes
            )
            category.card = card
            modelContext.insert(category)
        }
        dismiss()
    }
}
