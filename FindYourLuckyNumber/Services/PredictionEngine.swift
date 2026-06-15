import Foundation

protocol PredictionEngine {
    func dailyPrediction(for profile: UserProfile, on date: Date, history: [HistoryEntry]) -> DailyPrediction
    func weeklyLuckyNumber(for profile: UserProfile, from date: Date) -> Int
    func monthlyLuckyNumber(for profile: UserProfile, from date: Date) -> Int
}

struct MockPredictionEngine: PredictionEngine {
    private let colors = ["Royal Purple", "Antique Gold", "Moon Silver", "Emerald", "Ruby", "Sapphire"]
    private let directions = ["North", "North East", "East", "South East", "South", "West"]
    private let times = ["06:30 AM", "09:45 AM", "11:11 AM", "02:20 PM", "05:55 PM", "08:08 PM"]

    func dailyPrediction(for profile: UserProfile, on date: Date = Date(), history: [HistoryEntry] = []) -> DailyPrediction {
        let seed = seedValue(profile: profile, date: date, history: history)
        let primary = reduceToRange(seed, min: 1, max: 99)
        let secondary = secondaryNumbers(seed: seed, favoriteNumbers: profile.favoriteNumbers)
        let confidence = min(0.98, 0.64 + Double((seed % 31)) / 100)
        let categories = PredictionCategory.allCases.enumerated().map { index, category in
            categoryPrediction(category, seed: seed + index * 19, zodiac: profile.zodiacSign)
        }

        return DailyPrediction(
            date: Calendar.current.startOfDay(for: date),
            primaryLuckyNumber: primary,
            secondaryLuckyNumbers: secondary,
            confidenceScore: confidence,
            luckyColor: colors[seed % colors.count],
            luckyDirection: directions[(seed / 3) % directions.count],
            luckyTime: times[(seed / 7) % times.count],
            categories: categories
        )
    }

    func weeklyLuckyNumber(for profile: UserProfile, from date: Date = Date()) -> Int {
        let week = Calendar.current.component(.weekOfYear, from: date)
        return reduceToRange(seedValue(profile: profile, date: date, history: []) + week * 13, min: 1, max: 99)
    }

    func monthlyLuckyNumber(for profile: UserProfile, from date: Date = Date()) -> Int {
        let month = Calendar.current.component(.month, from: date)
        return reduceToRange(seedValue(profile: profile, date: date, history: []) + month * 29, min: 1, max: 99)
    }

    private func seedValue(profile: UserProfile, date: Date, history: [HistoryEntry]) -> Int {
        let calendar = Calendar.current
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 1
        let birthDay = calendar.component(.day, from: profile.birthDate)
        let birthMonth = calendar.component(.month, from: profile.birthDate)
        let nameValue = profile.name.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        let favorites = profile.favoriteNumbers.reduce(0, +)
        let historySignal = history.prefix(12).reduce(0) { $0 + $1.prediction.primaryLuckyNumber }
        return abs(nameValue + day + birthDay * 7 + birthMonth * 11 + favorites * 3 + historySignal + profile.zodiacSign.rawValue.count * 17)
    }

    private func secondaryNumbers(seed: Int, favoriteNumbers: [Int]) -> [Int] {
        var values = favoriteNumbers.filter { (1...99).contains($0) }
        var offset = 1
        while values.count < 4 {
            let candidate = reduceToRange(seed + offset * 23, min: 1, max: 99)
            if !values.contains(candidate) {
                values.append(candidate)
            }
            offset += 1
        }
        return Array(values.prefix(4))
    }

    private func categoryPrediction(_ category: PredictionCategory, seed: Int, zodiac: ZodiacSign) -> CategoryPrediction {
        let score = reduceToRange(seed, min: 58, max: 96)
        let prediction: String
        let recommendation: String

        switch category {
        case .love:
            prediction = "Warm conversations carry extra meaning for your \(zodiac.element.lowercased()) energy today."
            recommendation = "Choose one honest message over many vague signals."
        case .career:
            prediction = "A practical decision can unlock progress on work that has felt slow."
            recommendation = "Prioritize the task with the clearest measurable result."
        case .finance:
            prediction = "Small savings and patient timing are favored over impulsive spending."
            recommendation = "Review one recurring expense before making a new purchase."
        case .health:
            prediction = "Your body responds well to steady rhythm and simpler routines today."
            recommendation = "Take a short walk and keep hydration visible."
        case .travel:
            prediction = "Movement brings perspective, especially toward familiar places."
            recommendation = "Leave a buffer and choose the quieter route."
        }

        return CategoryPrediction(category: category, prediction: prediction, score: score, recommendation: recommendation)
    }

    private func reduceToRange(_ value: Int, min: Int, max: Int) -> Int {
        let span = max - min + 1
        return min + abs(value % span)
    }
}
