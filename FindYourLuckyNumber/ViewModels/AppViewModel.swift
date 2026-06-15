import Combine
import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published private(set) var profile: UserProfile?
    @Published var isOnboardingComplete = false

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        let savedProfile = container.profileRepository.loadProfile()
        self.profile = savedProfile
        self.isOnboardingComplete = savedProfile != nil
    }

    func completeOnboarding(with profile: UserProfile) {
        container.profileRepository.saveProfile(profile)
        self.profile = profile
        isOnboardingComplete = true
    }

    func updateProfile(_ profile: UserProfile) {
        container.profileRepository.saveProfile(profile)
        self.profile = profile
    }

    func deleteData() {
        try? container.historyRepository.deleteAll()
        container.profileRepository.deleteProfile()
        container.notificationManager.cancelAll()
        profile = nil
        isOnboardingComplete = false
    }
}
