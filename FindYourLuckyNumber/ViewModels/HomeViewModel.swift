import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var prediction: DailyPrediction?
    @Published private(set) var isLoading = false
    @Published var revealedNumber = 0

    private let profile: UserProfile
    private let historyRepository: PredictionHistoryRepository
    private let predictionEngine: PredictionEngine

    init(profile: UserProfile, historyRepository: PredictionHistoryRepository, predictionEngine: PredictionEngine) {
        self.profile = profile
        self.historyRepository = historyRepository
        self.predictionEngine = predictionEngine
    }

    func load() {
        isLoading = true
        let history = (try? historyRepository.fetchHistory()) ?? []
        let generated = predictionEngine.dailyPrediction(for: profile, on: Date(), history: history)
        prediction = generated
        try? historyRepository.save(generated)
        animateReveal(to: generated.primaryLuckyNumber)
        isLoading = false
    }

    func refresh() async {
        load()
    }

    func shareText() -> String {
        guard let prediction else { return "My Lucky Number is ready." }
        return "My lucky number today is \(prediction.primaryLuckyNumber) with \(Int(prediction.confidenceScore * 100))% confidence."
    }

    private func animateReveal(to value: Int) {
        revealedNumber = 0
        let steps = max(value, 1)
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * 0.012) { [weak self] in
                self?.revealedNumber = step
            }
        }
    }
}
