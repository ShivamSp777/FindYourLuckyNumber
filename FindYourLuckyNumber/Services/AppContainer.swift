import Foundation

@MainActor
final class AppContainer {
    let profileRepository: UserProfileRepository
    let historyRepository: PredictionHistoryRepository
    let predictionEngine: PredictionEngine
    let numerologyCalculator: NumerologyCalculator
    let notificationManager: NotificationManager

    init(
        profileRepository: UserProfileRepository,
        historyRepository: PredictionHistoryRepository,
        predictionEngine: PredictionEngine = MockPredictionEngine(),
        numerologyCalculator: NumerologyCalculator = NumerologyCalculator(),
        notificationManager: NotificationManager = NotificationManager()
    ) {
        self.profileRepository = profileRepository
        self.historyRepository = historyRepository
        self.predictionEngine = predictionEngine
        self.numerologyCalculator = numerologyCalculator
        self.notificationManager = notificationManager
    }
}
