import Foundation

struct UserProfile: Codable, Equatable {
    var name: String
    var birthDate: Date
    var birthTime: Date?
    var gender: GenderOption?
    var zodiacSign: ZodiacSign
    var favoriteNumbers: [Int]
    var notificationsEnabled: Bool
    var premiumPlan: PremiumPlan

    static let empty = UserProfile(
        name: "",
        birthDate: Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date(),
        birthTime: nil,
        gender: nil,
        zodiacSign: .aries,
        favoriteNumbers: [],
        notificationsEnabled: false,
        premiumPlan: .free
    )
}

enum GenderOption: String, Codable, CaseIterable, Identifiable {
    case female = "Female"
    case male = "Male"
    case nonBinary = "Non-binary"
    case preferNotToSay = "Prefer not to say"

    var id: String { rawValue }
}

enum ZodiacSign: String, Codable, CaseIterable, Identifiable {
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"

    var id: String { rawValue }

    var element: String {
        switch self {
        case .aries, .leo, .sagittarius: return "Fire"
        case .taurus, .virgo, .capricorn: return "Earth"
        case .gemini, .libra, .aquarius: return "Air"
        case .cancer, .scorpio, .pisces: return "Water"
        }
    }
}

enum PremiumPlan: String, Codable, CaseIterable {
    case free = "Free"
    case premium = "Premium"
}

enum PredictionCategory: String, Codable, CaseIterable, Identifiable {
    case love = "Love"
    case career = "Career"
    case finance = "Finance"
    case health = "Health"
    case travel = "Travel"

    var id: String { rawValue }
}

struct CategoryPrediction: Codable, Identifiable, Equatable {
    var id: PredictionCategory { category }
    let category: PredictionCategory
    let prediction: String
    let score: Int
    let recommendation: String
}

struct DailyPrediction: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    let primaryLuckyNumber: Int
    let secondaryLuckyNumbers: [Int]
    let confidenceScore: Double
    let luckyColor: String
    let luckyDirection: String
    let luckyTime: String
    let categories: [CategoryPrediction]

    init(
        id: UUID = UUID(),
        date: Date,
        primaryLuckyNumber: Int,
        secondaryLuckyNumbers: [Int],
        confidenceScore: Double,
        luckyColor: String,
        luckyDirection: String,
        luckyTime: String,
        categories: [CategoryPrediction]
    ) {
        self.id = id
        self.date = date
        self.primaryLuckyNumber = primaryLuckyNumber
        self.secondaryLuckyNumbers = secondaryLuckyNumbers
        self.confidenceScore = confidenceScore
        self.luckyColor = luckyColor
        self.luckyDirection = luckyDirection
        self.luckyTime = luckyTime
        self.categories = categories
    }
}

struct HistoryEntry: Codable, Identifiable, Equatable {
    let id: UUID
    var prediction: DailyPrediction
    var note: String
    var userFeedback: String
    var accuracy: Double
    var createdAt: Date

    init(
        id: UUID = UUID(),
        prediction: DailyPrediction,
        note: String = "",
        userFeedback: String = "",
        accuracy: Double = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.prediction = prediction
        self.note = note
        self.userFeedback = userFeedback
        self.accuracy = accuracy
        self.createdAt = createdAt
    }
}

struct NumerologyResult: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let number: Int
    let steps: [String]
    let explanation: String
}

struct AchievementBadge: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let isUnlocked: Bool
}

struct InsightSummary: Equatable {
    let mostFrequentNumbers: [Int]
    let averageConfidence: Double
    let monthlyCount: Int
    let streak: Int
    let rewardPoints: Int
    let badges: [AchievementBadge]
}
