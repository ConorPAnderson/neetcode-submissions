import SwiftUI
import SwiftData

struct CardDetailView: View {
    @Bindable var card: CreditCard
    @Environment(\.modelContext) private var modelContext

    @State private var showingEditCard = false
    @State private var showingAddBenefit = false
    @State private var showingAddCategory = false
    @State private var benefitToEditState: Benefit?
    @State private var categoryToEditState: RewardCategory?
    @State private var selectedSection = 0

    private var sortedBenefits: [Benefit] {
        card.benefits.sorted { $0.value > $1.value }
    }

    private var sortedCategories: [RewardCategory] {
        card.rewardCategories.sorted { $0.multiplier > $1.multiplier }
    }

    private var totalBenefitValue: Double {
        card.benefits.reduce(0) { $0 + $1.value }
    }

    private var usedBenefitValue: Double {
        card.benefits.filter { $0.isUsedThisPeriod }.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        List {
            Section {
                cardHeader
                    .listRowInsets(EdgeInsets())
                    .padding()
                    .listRowSeparator(.hidden)
            }

            Section {
                Picker("Section", selection: $selectedSection) {
                    Text("Benefits").tag(0)
                    Text("Reward Categories").tag(1)
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
            }

            if selectedSection == 0 {
                benefitsSection
            } else {
                categoriesSection
            }

            Section {
                Toggle("Card is active", isOn: $card.isActive)
            }

            if !card.notes.isEmpty {
                Section("Notes") {
                    Text(card.notes)
                }
            }
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showingEditCard = true }
            }
        }
        .sheet(isPresented: $showingEditCard) {
            AddEditCardView(cardToEdit: card)
        }
        .sheet(isPresented: $showingAddBenefit) {
            AddEditBenefitView(card: card)
        }
        .sheet(isPresented: $showingAddCategory) {
            AddEditRewardCategoryView(card: card)
        }
        .sheet(item: $benefitToEditState) { benefit in
            AddEditBenefitView(card: card, benefitToEdit: benefit)
        }
        .sheet(item: $categoryToEditState) { category in
            AddEditRewardCategoryView(card: card, categoryToEdit: category)
        }
    }

    private var cardHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: card.colorHex), Color(hex: card.colorHex).opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 170)
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(card.name)
                            .font(.title3.bold())
                        Text(card.last4.isEmpty ? card.issuer : "\(card.issuer)  ••••  \(card.last4)")
                            .font(.subheadline)
                        Text(card.network)
                            .font(.caption)
                    }
                    .foregroundStyle(.white)
                    .padding(20)
                }

            HStack {
                Label(card.annualFee.formatted(.currency(code: "USD")) + " annual fee", systemImage: "dollarsign.circle")
                Spacer()
                Text("Renews \(card.nextRenewalDate.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)

            let feeTotal = max(card.annualFee, 1)
            let progressValue = min(usedBenefitValue, feeTotal)
            ProgressView(value: progressValue, total: feeTotal)
            Text("\(usedBenefitValue.formatted(.currency(code: "USD"))) of \(totalBenefitValue.formatted(.currency(code: "USD"))) in benefits used")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var benefitsSection: some View {
        Section {
            ForEach(sortedBenefits) { benefit in
                BenefitRow(benefit: benefit)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            modelContext.delete(benefit)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            benefitToEditState = benefit
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }

            Button {
                showingAddBenefit = true
            } label: {
                Label("Add Benefit", systemImage: "plus.circle")
            }
        } header: {
            Text("Benefits (\(card.benefits.count))")
        } footer: {
            if card.benefits.isEmpty {
                Text("Add the perks this card offers, like travel credits or lounge access, to track usage each period.")
            }
        }
    }

    private var categoriesSection: some View {
        Section {
            ForEach(sortedCategories) { category in
                RewardCategoryRow(category: category)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            modelContext.delete(category)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            categoryToEditState = category
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }

            Button {
                showingAddCategory = true
            } label: {
                Label("Add Reward Category", systemImage: "plus.circle")
            }
        } header: {
            Text("Reward Categories (\(card.rewardCategories.count))")
        } footer: {
            if card.rewardCategories.isEmpty {
                Text("Add the spending categories this card rewards, like Dining 3x, to know when to use it.")
            }
        }
    }
}
