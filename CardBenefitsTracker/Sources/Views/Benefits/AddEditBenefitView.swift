import SwiftUI
import SwiftData

struct AddEditBenefitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let card: CreditCard
    var benefitToEdit: Benefit? = nil

    @State private var title = ""
    @State private var detail = ""
    @State private var value = ""
    @State private var category = CardPresets.benefitCategories[0]
    @State private var frequency: BenefitFrequency = .annual

    private var isEditing: Bool { benefitToEdit != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Benefit") {
                    TextField("Title (e.g. $200 Travel Credit)", text: $title)
                    TextField("Details (optional)", text: $detail, axis: .vertical)
                }
                Section("Value & Frequency") {
                    TextField("Value ($)", text: $value)
                        .keyboardType(.decimalPad)
                    Picker("Resets", selection: $frequency) {
                        ForEach(BenefitFrequency.allCases) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                }
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(CardPresets.benefitCategories, id: \.self) { Text($0).tag($0) }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Benefit" : "Add Benefit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear(perform: loadIfEditing)
        }
    }

    private func loadIfEditing() {
        guard let benefit = benefitToEdit else { return }
        title = benefit.title
        detail = benefit.detail
        value = benefit.value == 0 ? "" : String(benefit.value)
        category = benefit.category
        frequency = benefit.frequency
    }

    private func save() {
        let amount = Double(value) ?? 0
        if let benefit = benefitToEdit {
            benefit.title = title
            benefit.detail = detail
            benefit.value = amount
            benefit.category = category
            benefit.frequency = frequency
        } else {
            let benefit = Benefit(
                title: title,
                detail: detail,
                value: amount,
                frequency: frequency,
                category: category
            )
            benefit.card = card
            modelContext.insert(benefit)
        }
        dismiss()
    }
}
