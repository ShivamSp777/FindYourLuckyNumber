import SwiftUI

struct ContentView: View {
    let container: AppContainer
    @StateObject private var appViewModel: AppViewModel

    init(container: AppContainer) {
        self.container = container
        _appViewModel = StateObject(wrappedValue: AppViewModel(container: container))
    }

    var body: some View {
        Group {
            if appViewModel.isOnboardingComplete, let profile = appViewModel.profile {
                MainTabView(container: container, appViewModel: appViewModel, profile: profile)
            } else {
                OnboardingView { profile in
                    appViewModel.completeOnboarding(with: profile)
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: appViewModel.isOnboardingComplete)
    }
}
