import Combine
import Foundation

@MainActor
final class DailyPredictionViewModel: ObservableObject {
    @Published private(set) var prediction: DailyPrediction

    init(profile: UserProfile, historyRepository: PredictionHistoryRepository, predictionEngine: PredictionEngine) {
        let history = (try? historyRepository.fetchHistory()) ?? []
        self.prediction = predictionEngine.dailyPrediction(for: profile, on: Date(), history: history)
    }
}
