//
//  DeckView.swift
//  CardsLearning
//
//  Created by Anastasiia Bugaeva on 07.07.2024.
//

import SwiftUI

struct DeckView: View {
    @EnvironmentObject private var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var cardItems: FetchedResults<Card>
    @State private var isPresented: Bool = false
    private var deck: Deck

    init(deck: Deck) {
        self.deck = deck
        _cardItems = FetchRequest<Card>(sortDescriptors: [SortDescriptor(\Card.nextShowTime_, order: .forward)], predicate: NSPredicate(format: "deck = %@", deck))
    }

    var body: some View {
        VStack {
            Text(cardItems.filter({ card in
                card.nextShowTime_ ?? .now < Date.now
            }).count.description + " cards to study")
                .padding(4)
            Text("\(cardItems.count) cards total")
                .padding(.bottom)

            NavigationLink(destination: CardView(deck: deck)) {
                Text("Study Cards")
                    .tint(.primary)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(.fill)
            .cornerRadius(6)

            Button {
                isPresented = true
            } label: {
                Text("Add Card +")
                    .tint(.primary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(.fill)
            .cornerRadius(6)
            .padding()


            List {
                ForEach(cardItems) { card in
                    VStack(alignment: .leading) {
                        Text(card.frontText_ ?? "nil")
                        Text(card.backText_ ?? "nil")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle("English words")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {

                } label: {
                    Image(systemName: "ellipsis")
                        .tint(.primary)
                        .rotationEffect(.degrees(90))
                }

            }
        }
        .sheet(isPresented: $isPresented, content: {
            NewCardView(deck: deck)
                .presentationDetents([.medium])
        })
    }
}

#Preview {
    DeckView(deck: Deck())
}
