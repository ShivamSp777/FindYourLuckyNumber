import Combine
import Foundation

@MainActor
final class InsightsViewModel: ObservableObject {
    @Published private(set) var history: [HistoryEntry] = []
    @Published private(set) var summary = InsightSummary(mostFrequentNumbers: [], averageConfidence: 0, monthlyCount: 0, streak: 0, rewardPoints: 0, badges: [])
    @Published var numerologyResults: [NumerologyResult] = []

    private let profile: UserProfile
    private let historyRepository: PredictionHistoryRepository
    private let calculator: NumerologyCalculator

    init(profile: UserProfile, historyRepository: PredictionHistoryRepository, calculator: NumerologyCalculator) {
        self.profile = profile
        self.historyRepository = historyRepository
        self.calculator = calculator
        reload()
    }

    func reload() {
        history = (try? historyRepository.fetchHistory()) ?? []
        numerologyResults = calculator.calculate(name: profile.name, birthDate: profile.birthDate)
        summary = makeSummary(from: history)
    }

    private func makeSummary(from entries: [HistoryEntry]) -> InsightSummary {
        let counts = Dictionary(grouping: entries.map { $0.prediction.primaryLuckyNumber }, by: { $0 }).mapValues(\.count)
        let frequent = counts.sorted { lhs, rhs in
            lhs.value == rhs.value ? lhs.key < rhs.key : lhs.value > rhs.value
        }.prefix(5).map(\.key)
        let average = entries.isEmpty ? 0 : entries.map { $0.prediction.confidenceScore }.reduce(0, +) / Double(entries.count)
        let month = Calendar.current.component(.month, from: Date())
        let monthlyCount = entries.filter { Calendar.current.component(.month, from: $0.prediction.date) == month }.count
        let streak = currentStreak(entries: entries)
        let points = entries.count * 10 + streak * 25
        let badges = [
            AchievementBadge(title: "First Reveal", description: "Generated your first lucky number", isUnlocked: !entries.isEmpty),
            AchievementBadge(title: "Seven Day Signal", description: "Built a 7 day prediction streak", isUnlocked: streak >= 7),
            AchievementBadge(title: "Insight Seeker", description: "Stored 20 predictions", isUnlocked: entries.count >= 20)
        ]
        return InsightSummary(mostFrequentNumbers: frequent, averageConfidence: average, monthlyCount: monthlyCount, streak: streak, rewardPoints: points, badges: badges)
    }

    private func currentStreak(entries: [HistoryEntry]) -> Int {
        let days = Set(entries.map { Calendar.current.startOfDay(for: $0.prediction.date) })
        var date = Calendar.current.startOfDay(for: Date())
        var streak = 0
        while days.contains(date) {
            streak += 1
            guard let previous = Calendar.current.date(byAdding: .day, value: -1, to: date) else { break }
            date = previous
        }
        return streak
    }
}
