//
//  HomeViewModel.swift
//  MyLuckyNumber
//
//  Created by Shivam Kumar Pandey on 11/06/26.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    

    // MARK: Input

    @Published var name: String = ""
    @Published var birthDate = Date()
    @Published var validationMessage: String?

    // MARK: Output

    //@Published var luckyNumber: Int?
    @Published var showResult = false
    @Published var luckyResult: LuckyResult?

    private let service: LuckyNumberServiceProtocol

    init(
        service: LuckyNumberServiceProtocol? = nil
    ) {
        self.service = service ?? LuckyNumberService()
    }

    var isGenerateEnabled: Bool {
        !name.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    func updateName(_ newName: String) {

        guard name != newName else {
            return
        }

        name = newName
        birthDate = Date()
        validationMessage = nil
    }

    func setSavedNameIfNeeded(_ savedName: String?) {

        guard name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let savedName = savedName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !savedName.isEmpty else {
            return
        }

        name = savedName
        validationMessage = nil
    }

    func generateLuckyNumber(
        modelContext: ModelContext
    ) {

        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        name = trimmedName

        let calculationDate = Date()

        let number = service.generateLuckyNumber(
            name: trimmedName,
            birthDate: birthDate,
            currentDate: calculationDate
        )

        let record = LuckyNumberRecord(
            name: trimmedName,
            birthDate: birthDate,
            calculationDate: calculationDate,
            luckyNumber: number
        )

        modelContext.insert(record)
        luckyResult = LuckyResult(number: number)
    }
    
    func validateInputs() {

        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if trimmedName.isEmpty {
            validationMessage = "Please enter your name."
            return
        }

        validationMessage = nil
    }
}
