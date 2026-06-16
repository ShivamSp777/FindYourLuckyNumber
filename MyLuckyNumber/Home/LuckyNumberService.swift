//
//  LuckyNumberService.swift
//  MyLuckyNumber
//
//  Created by Shivam Kumar Pandey on 11/06/26.
//

import Foundation

protocol LuckyNumberServiceProtocol {
    func generateLuckyNumber(
        name: String,
        birthDate: Date,
        currentDate: Date
    ) -> Int
}

final class LuckyNumberService: LuckyNumberServiceProtocol {

    func generateLuckyNumber(
        name: String,
        birthDate: Date,
        currentDate: Date
    ) -> Int {

        let dobSum = digitSum(for: birthDate)
        let currentDateSum = digitSum(for: currentDate)

        let nameSum = name
            .uppercased()
            .compactMap { $0.asciiValue }
            .map { Int($0 - 64) }
            .reduce(0, +)

        let combined = dobSum + nameSum + currentDateSum

        return digitalRoot(combined)
    }

    private func digitSum(for date: Date) -> Int {

        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"

        return formatter.string(from: date)
            .compactMap { Int(String($0)) }
            .reduce(0, +)
    }

    private func digitalRoot(_ number: Int) -> Int {

        var value = number

        while value > 9 {
            value = String(value)
                .compactMap { Int(String($0)) }
                .reduce(0, +)
        }

        return value
    }
}
