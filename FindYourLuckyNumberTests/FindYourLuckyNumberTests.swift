import XCTest
@testable import FindYourLuckyNumber

final class FindYourLuckyNumberTests: XCTestCase {
    func testNumerologyLifePathReducesBirthDateDigits() {
        let calculator = NumerologyCalculator()
        let date = Calendar.current.date(from: DateComponents(year: 1990, month: 7, day: 15))!

        let result = calculator.lifePathNumber(from: date)

        XCTAssertEqual(result.title, "Life Path")
        XCTAssertEqual(result.number, 5)
        XCTAssertFalse(result.steps.isEmpty)
    }

    func testPredictionEngineIsDeterministicForSameInputs() {
        let engine = MockPredictionEngine()
        let profile = UserProfile(
            name: "Maya",
            birthDate: Calendar.current.date(from: DateComponents(year: 1994, month: 2, day: 8))!,
            birthTime: nil,
            gender: .female,
            zodiacSign: .aquarius,
            favoriteNumbers: [7, 11],
            notificationsEnabled: false,
            premiumPlan: .free
        )
        let date = Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 15))!

        let first = engine.dailyPrediction(for: profile, on: date, history: [])
        let second = engine.dailyPrediction(for: profile, on: date, history: [])

        XCTAssertEqual(first.primaryLuckyNumber, second.primaryLuckyNumber)
        XCTAssertEqual(first.secondaryLuckyNumbers, second.secondaryLuckyNumbers)
        XCTAssertEqual(first.categories.count, PredictionCategory.allCases.count)
        XCTAssertTrue((1...99).contains(first.primaryLuckyNumber))
    }
}
