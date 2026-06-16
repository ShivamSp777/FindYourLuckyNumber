//
//  LuckyNumberRecord.swift
//  MyLuckyNumber
//
//  Created by Shivam Kumar Pandey on 16/06/26.
//

import Foundation
import SwiftData

@Model
final class LuckyNumberRecord {
    var name: String
    var birthDate: Date
    var calculationDate: Date
    var luckyNumber: Int

    init(
        name: String,
        birthDate: Date,
        calculationDate: Date,
        luckyNumber: Int
    ) {
        self.name = name
        self.birthDate = birthDate
        self.calculationDate = calculationDate
        self.luckyNumber = luckyNumber
    }
}
