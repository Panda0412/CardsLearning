//
//  SM2Engine.swift
//  CardsLearning
//
//  Created by Anastasiia Bugaeva on 01.09.2024.
//

import Foundation
import CoreData

public struct SM2Engine {
    static let easyModifier: Double = 1.3
    static let againModifier: Double = 0.1
    static let secondsInDay: Double = Double(60 * 60 * 24)

    static func getIntervals(flashcard: Card) -> [Double] {
        let prevInterval: Double = Double(flashcard.prevInterval_)
        let delay: TimeInterval = Date.now.timeIntervalSince(flashcard.nextShowTime_ ?? .now)
        let flashcardFactor: Double = Double(flashcard.factor_) / 1000

        let againInterval: Double = max(
            prevInterval * againModifier,
            60
        )
        let hardInterval: Double = max(
            prevInterval + secondsInDay,
            (prevInterval + delay / 4) * 1.2)
        let goodInterval: Double = max(
            hardInterval + secondsInDay,
            (prevInterval + delay / 2) * flashcardFactor)
        let easyInterval: Double = max(
            goodInterval + secondsInDay,
            (prevInterval + delay) * flashcardFactor * easyModifier)

        return [againInterval, hardInterval, goodInterval, easyInterval]
    }

    static func gradeFlashcard(
        flashcard: Card,
        grade: GradeLevel,
        interval: Double,
        viewContext: NSManagedObjectContext
    ) {
        flashcard.nextShowTime_ = .now.addingTimeInterval(interval)
        flashcard.prevInterval_ = interval

        let oldFactor: Int16 = flashcard.factor_
        let newFactor: Int16
        switch grade {
        case .again:
            newFactor = oldFactor - 200
        case .hard:
            newFactor = oldFactor - 150
        case .good:
            newFactor = oldFactor
        case .easy:
            newFactor = oldFactor + 150
        }
        flashcard.factor_ = max(1300, newFactor)

        let gradeModel: Grade = .init(context: viewContext)
        gradeModel.timestamp_ = .now
        gradeModel.value_ = Int16(grade.rawValue)
        gradeModel.card = flashcard

        do {
            try viewContext.save()
        } catch(let err) {
            print("err", err)
        }

        print()
    }
}
