import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CreditCard.sortOrder) private var cards: [CreditCard]
    @State private var showingAddCard = false

    private var totalAnnualFees: Double {
        cards.filter { $0.isActive }.reduce(0) { $0 + $1.annualFee }
    }

    var body: some View {
        NavigationStack {
            List {
                if !cards.isEmpty {
                    Section {
                        HStack {
                            Text("Total annual fees")
                            Spacer()
                            Text(totalAnnualFees, format: .currency(code: "USD"))
                                .fontWeight(.semibold)
                        }
                    }
                }

                Section {
                    ForEach(cards) { card in
                        NavigationLink(value: card) {
                            CardRow(card: card)
                        }
                    }
                    .onDelete(perform: deleteCards)
                } header: {
                    if !cards.isEmpty { Text("Your Cards") }
                }

                if cards.isEmpty {
                    ContentUnavailableView(
                        "No Cards Yet",
                        systemImage: "creditcard",
                        description: Text("Add your first credit card to start tracking benefits and rewards.")
                    )
                }
            }
            .navigationTitle("My Cards")
            .navigationDestination(for: CreditCard.self) { card in
                CardDetailView(card: card)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddCard = true
                    } label: {
                        Label("Add Card", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCard) {
                AddEditCardView()
            }
        }
    }

    private func deleteCards(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cards[index])
        }
    }
}
