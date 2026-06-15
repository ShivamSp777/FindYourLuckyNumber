import Combine
import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var profile = UserProfile.empty
    @Published var favoriteNumberText = ""

    let totalSteps = 5

    var progress: Double {
        Double(currentStep + 1) / Double(totalSteps)
    }

    var canContinue: Bool {
        switch currentStep {
        case 0: return !profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 4: return !favoriteNumbers.isEmpty
        default: return true
        }
    }

    var favoriteNumbers: [Int] {
        favoriteNumberText
            .split { $0 == "," || $0 == " " }
            .compactMap { Int($0) }
            .filter { (1...99).contains($0) }
    }

    func next() {
        profile.favoriteNumbers = Array(Set(favoriteNumbers)).sorted()
        currentStep = min(currentStep + 1, totalSteps - 1)
    }

    func back() {
        currentStep = max(currentStep - 1, 0)
    }

    func finalProfile() -> UserProfile {
        var final = profile
        final.favoriteNumbers = Array(Set(favoriteNumbers)).sorted()
        return final
    }
}
