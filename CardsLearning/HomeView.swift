//
//  HomeView.swift
//  CardsLearning
//
//  Created by Anastasiia Bugaeva on 20.08.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var deckItems: FetchedResults<Deck>
    @FetchRequest(sortDescriptors: []) private var cardItems: FetchedResults<Card>
    @State private var isPresented: Bool = false

    var body: some View {
        VStack {
            if deckItems.isEmpty {
                Text("Nothing yet")
                Button {
                    isPresented = true
                } label: {
                    Text("Add Deck +")
                        .tint(.primary)
                }
                .padding()
                .background(.fill)
                .cornerRadius(6)
                .padding()
            } else {
                List {
                    ForEach(deckItems) { deck in
                        NavigationLink(destination: DeckView(deck: deck)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(deck.name_ ?? "empty")
                                HStack(spacing: 0) {
                                    Text("\(deck.cards?.count.description ?? "0") cards, ")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(cardItems.filter({ card in
                                        card.deck == deck && card.nextShowTime_ ?? .now < Date.now
                                    }).count.description + " to study")
                                        .font(.bold(.caption)())
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }

                }
                .padding()
                .listStyle(.plain)
                .scrollIndicators(.hidden)

                Spacer()
            }
        }
        .navigationTitle("My Decks")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isPresented = true
                } label: {
                    Image(systemName: "plus")
                        .tint(.primary)
                }
            }
        }
        .sheet(isPresented: $isPresented, content: {
            NewDeckView()
                .presentationDetents([.medium])
        })
    }
}

#Preview {
    HomeView()
}
