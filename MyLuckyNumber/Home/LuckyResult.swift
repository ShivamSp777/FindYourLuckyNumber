//
//  LuckyResult.swift
//  MyLuckyNumber
//
//  Created by Shivam Kumar Pandey on 11/06/26.
//

import Foundation

struct LuckyInfo {

    let title: String
    let description: String
    let luckyColor: String
    let luckyDay: String
}

struct LuckyResult: Identifiable, Hashable {
    let id = UUID()
    let number: Int
}
