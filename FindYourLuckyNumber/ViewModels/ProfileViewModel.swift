import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var exportText = ""

    private let appViewModel: AppViewModel
    private let historyRepository: PredictionHistoryRepository
    private let notificationManager: NotificationManager

    init(profile: UserProfile, appViewModel: AppViewModel, historyRepository: PredictionHistoryRepository, notificationManager: NotificationManager) {
        self.profile = profile
        self.appViewModel = appViewModel
        self.historyRepository = historyRepository
        self.notificationManager = notificationManager
    }

    func save() {
        appViewModel.updateProfile(profile)
    }

    func toggleNotifications(_ enabled: Bool) {
        profile.notificationsEnabled = enabled
        save()
        Task {
            if enabled, await notificationManager.requestAuthorization() {
                await notificationManager.scheduleDailyLuckyNumber()
                await notificationManager.scheduleWeeklySummary()
            } else {
                notificationManager.cancelAll()
            }
        }
    }

    func exportHistory() {
        let entries = (try? historyRepository.fetchHistory()) ?? []
        exportText = entries.map { entry in
            "\(entry.prediction.date.formatted(date: .abbreviated, time: .omitted)): \(entry.prediction.primaryLuckyNumber), confidence \(Int(entry.prediction.confidenceScore * 100))%"
        }.joined(separator: "\n")
    }

    func deleteAllData() {
        appViewModel.deleteData()
    }
}
