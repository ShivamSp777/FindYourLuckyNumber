//
//  MyLuckyNumberTests.swift
//  MyLuckyNumberTests
//
//  Created by Shivam Kumar Pandey on 07/06/26.
//

import Foundation
import Testing
@testable import MyLuckyNumber

struct MyLuckyNumberTests {

    @Test func luckyNumberIncludesCurrentDate() throws {

        let service = LuckyNumberService()
        let birthDate = try date(day: 1, month: 1, year: 2000)
        let currentDate = try date(day: 1, month: 1, year: 2000)

        let luckyNumber = service.generateLuckyNumber(
            name: "A",
            birthDate: birthDate,
            currentDate: currentDate
        )

        #expect(luckyNumber == 9)
    }

    @Test func changingCurrentDateChangesLuckyNumber() throws {

        let service = LuckyNumberService()
        let birthDate = try date(day: 1, month: 1, year: 2000)
        let firstCurrentDate = try date(day: 1, month: 1, year: 2000)
        let secondCurrentDate = try date(day: 2, month: 1, year: 2000)

        let firstLuckyNumber = service.generateLuckyNumber(
            name: "A",
            birthDate: birthDate,
            currentDate: firstCurrentDate
        )

        let secondLuckyNumber = service.generateLuckyNumber(
            name: "A",
            birthDate: birthDate,
            currentDate: secondCurrentDate
        )

        #expect(firstLuckyNumber == 9)
        #expect(secondLuckyNumber == 1)
    }

    @MainActor
    @Test func changingNameResetsBirthDateToToday() throws {

        let viewModel = HomeViewModel()
        viewModel.birthDate = try date(day: 1, month: 1, year: 2000)

        viewModel.updateName("Shivam")

        #expect(viewModel.name == "Shivam")
        #expect(Calendar.current.isDateInToday(viewModel.birthDate))
    }

    @MainActor
    @Test func savedNamePrefillDoesNotChangeBirthDate() throws {

        let viewModel = HomeViewModel()
        let selectedBirthDate = try date(day: 1, month: 1, year: 2000)
        viewModel.birthDate = selectedBirthDate

        viewModel.setSavedNameIfNeeded("Shivam")

        #expect(viewModel.name == "Shivam")
        #expect(viewModel.birthDate == selectedBirthDate)
    }

    private func date(
        day: Int,
        month: Int,
        year: Int
    ) throws -> Date {

        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.day = day
        components.month = month
        components.year = year

        return try #require(components.date)
    }
}
