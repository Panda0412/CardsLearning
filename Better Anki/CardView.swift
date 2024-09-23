//
//  CardView.swift
//  Better Anki
//
//  Created by Anastasiia Bugaeva on 07.07.2024.
//

import SwiftUI

struct CardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var cardItems: FetchedResults<Card>

    @State private var currentCardIntervals: [Double] = .init()
    @State private var currentCardIndex: Int = .zero
    @State private var currentCard: Card?
    @State private var isCardOpen: Bool = false

    private let deck: Deck

    init(deck: Deck) {
        self.deck = deck
        _cardItems = FetchRequest<Card>(
            sortDescriptors: [SortDescriptor(
                \Card.nextShowTime_,
                 order: .forward)],
            predicate: NSPredicate(
                format: "deck = %@ AND nextShowTime_ <= %@",
                deck,
                Date.now as CVarArg))
    }

    var body: some View {
        VStack {
            Button {
                isCardOpen.toggle()
            } label: {
                VStack {
                    Text(currentCard?.frontText_ ?? "")
                        .tint(.primary)
                        .padding(.top)
                    if isCardOpen {
                        Rectangle()
                            .frame(height: 1)
                            .tint(.gray)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 15)
                        Text(currentCard?.backText_ ?? "")
                            .tint(.primary)
                        Spacer()
                        Text("Tap to hide answer")
                            .tint(.secondary)
                            .font(.caption)
                    } else {
                        Spacer()
                        Text("Tap to show answer")
                            .tint(.secondary)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(.fill)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 30)

            Spacer()

            HStack {
                Button {
                    gradeTapAction(grade: .again)
                } label: {
                    VStack {
                        Text(GradeLevel.again.description)
                            .tint(.black)
                            .font(.headline)
                        if currentCardIntervals.isEmpty == false {
                            Text(getIntervalString(
                                interval: currentCardIntervals[0]))
                            .tint(.black)
                            .font(.subheadline)
                        }
                    }

                }
                .padding()
                .background(Color(red: 0.98, green: 0.906, blue: 0.906))
                .clipShape(RoundedRectangle(cornerRadius: 4))

                Button {
                    gradeTapAction(grade: .hard)
                } label: {
                    VStack {
                        Text(GradeLevel.hard.description)
                            .tint(.black)
                            .font(.headline)
                        if currentCardIntervals.isEmpty == false {
                            Text(getIntervalString(
                                interval: currentCardIntervals[1]))
                            .tint(.black)
                            .font(.subheadline)
                        }
                    }

                }
                .padding()
                .background(Color(red: 0.965, green: 0.898, blue: 0.765))
                .clipShape(RoundedRectangle(cornerRadius: 4))

                Button {
                    gradeTapAction(grade: .good)
                } label: {
                    VStack {
                        Text(GradeLevel.good.description)
                            .tint(.black)
                            .font(.headline)
                        if currentCardIntervals.isEmpty == false {
                            Text(getIntervalString(
                                interval: currentCardIntervals[2]))
                            .tint(.black)
                            .font(.subheadline)
                        }
                    }

                }
                .padding()
                .background(Color(red: 0.855, green: 0.953, blue: 0.792))
                .clipShape(RoundedRectangle(cornerRadius: 4))

                Button {
                    gradeTapAction(grade: .easy)
                } label: {
                    VStack {
                        Text(GradeLevel.easy.description)
                            .tint(.black)
                            .font(.headline)
                        if currentCardIntervals.isEmpty == false {
                            Text(getIntervalString(
                                interval: currentCardIntervals[3]))
                            .tint(.black)
                            .font(.subheadline)
                        }
                    }

                }
                .padding()
                .background(Color(red: 0.729, green: 0.89, blue: 0.957))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .padding(.top, 30)
        }
        .padding(.top, 40)
        .navigationTitle("\(currentCardIndex + 1)/\(currentCardIndex + cardItems.count)")
        .toolbarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear() {
            currentCard = cardItems.first
            updateCardIntervals()
        }
    }

    private func updateCardIntervals() {
        if let currentCard {
            currentCardIntervals = SM2Engine.getIntervals(flashcard: currentCard)
        }
    }

    private func getIntervalString(interval: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.zeroFormattingBehavior = .dropAll
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: interval) ?? "err"
    }

    private func gradeTapAction(grade: GradeLevel) {
        isCardOpen = false
        if let currentCard {
            SM2Engine.gradeFlashcard(
                flashcard: currentCard,
                grade: grade,
                interval: currentCardIntervals[grade.rawValue],
                viewContext: viewContext)
        }

        if cardItems.count == 0 {
            dismiss()
        } else {
            currentCardIndex += 1
            currentCard = cardItems.first
            updateCardIntervals()
        }
    }
}

#Preview {
    CardView(deck: Deck())
}

public enum GradeLevel: Int, CustomStringConvertible {
    case again
    case hard
    case good
    case easy

    public var description: String {
        switch self {
        case .again: "Again"
        case .hard: "Hard"
        case .good: "Good"
        case .easy: "Easy"
        }
    }
}
