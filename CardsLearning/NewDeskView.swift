//
//  NewDeckView.swift
//  CardsLearning
//
//  Created by Anastasiia Bugaeva on 21.08.2024.
//

import SwiftUI

struct NewDeckView: View {
    enum FocusedField {
        case deckName
    }
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @State private var deckName: String = ""
    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) private var dismiss
    
    private func addItem() {
        let newDeck = Deck(context: viewContext)
        newDeck.name_ = self.deckName
        do {
            try viewContext.save()
        } catch(let err) {
            print("err", err)
        }
        dismiss()
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                TextField("Deck Name", text: $deckName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.primary, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.top, 50)
                    .focused($focusedField, equals: .deckName)

                Button {
                    addItem()
                } label: {
                    Text("Create")
                        .tint(.primary)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding()
                .background(.fill)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                Spacer()

            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .navigationTitle("New Deck")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(.primary)
                    }

                }
            }
        }
        .onAppear {
            focusedField = .deckName
        }
    }
}

#Preview {
    NewDeckView()
}
