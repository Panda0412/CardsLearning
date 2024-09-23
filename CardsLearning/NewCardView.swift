//
//  NewCardView.swift
//  CardsLearning
//
//  Created by Anastasiia Bugaeva on 21.08.2024.
//

import SwiftUI

struct NewCardView: View {
    enum FocusedField {
        case frontText, backText
    }

    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    var deck: Deck
    @FocusState private var focusedField: FocusedField?
    @State private var frontText: String = ""
    @State private var backText: String = ""
    @Environment(\.dismiss) private var dismiss

    private func addItem() {
        let newCard = Card(context: viewContext)
        newCard.frontText_ = self.frontText
        newCard.backText_ = self.backText
        newCard.nextShowTime_ = .now
        newCard.prevInterval_ = .zero
        newCard.factor_ = 1300
        newCard.deck = self.deck
        do {
            try viewContext.save()
        } catch(let err) {
            print("err", err)
        }
        dismiss()
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("👀 Front", text: $frontText)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.primary, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.top, 50)
                    .focused($focusedField, equals: .frontText)
                Text("You will see")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .padding(.bottom, 25)

                TextField("🤔 Back", text: $backText)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.primary, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .focused($focusedField, equals: .backText)
                Text("You will need to guess")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .padding(.bottom, 25)

                Button {
                    addItem()
                } label: {
                    Text("Add")
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
            .navigationTitle("New Card")
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
            focusedField = .frontText
        }
    }
}

#Preview {
    NewCardView(deck: Deck())
}
