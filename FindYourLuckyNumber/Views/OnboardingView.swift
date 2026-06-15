import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: (UserProfile) -> Void

    var body: some View {
        AppBackground {
            VStack(spacing: 24) {
                ProgressView(value: viewModel.progress)
                    .tint(AppTheme.gold)
                    .padding(.horizontal)
                    .accessibilityLabel("Onboarding progress")

                TabView(selection: $viewModel.currentStep) {
                    nameStep.tag(0)
                    birthStep.tag(1)
                    identityStep.tag(2)
                    zodiacStep.tag(3)
                    favoriteStep.tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentStep)

                HStack(spacing: 12) {
                    if viewModel.currentStep > 0 {
                        Button("Back") { viewModel.back() }
                            .foregroundStyle(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                    }

                    Button(viewModel.currentStep == viewModel.totalSteps - 1 ? "Begin" : "Continue") {
                        if viewModel.currentStep == viewModel.totalSteps - 1 {
                            onComplete(viewModel.finalProfile())
                        } else {
                            viewModel.next()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.canContinue)
                    .opacity(viewModel.canContinue ? 1 : 0.45)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }

    private var nameStep: some View {
        onboardingCard(symbol: "sparkles", title: "My Lucky Number", subtitle: "Personalize your daily numerology signal.") {
            TextField("Name", text: $viewModel.profile.name)
                .textInputAutocapitalization(.words)
                .padding(14)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.white)
        }
    }

    private var birthStep: some View {
        onboardingCard(symbol: "moon.stars.fill", title: "Birth Details", subtitle: "Date is required. Time improves future forecast precision.") {
            DatePicker("Date of Birth", selection: $viewModel.profile.birthDate, displayedComponents: .date)
            Toggle("Add birth time", isOn: Binding(
                get: { viewModel.profile.birthTime != nil },
                set: { viewModel.profile.birthTime = $0 ? Date() : nil }
            ))
            if viewModel.profile.birthTime != nil {
                DatePicker("Time of Birth", selection: Binding(
                    get: { viewModel.profile.birthTime ?? Date() },
                    set: { viewModel.profile.birthTime = $0 }
                ), displayedComponents: .hourAndMinute)
            }
        }
    }

    private var identityStep: some View {
        onboardingCard(symbol: "person.crop.circle", title: "Optional Profile", subtitle: "These details can be edited later.") {
            Picker("Gender", selection: $viewModel.profile.gender) {
                Text("Not set").tag(GenderOption?.none)
                ForEach(GenderOption.allCases) { option in
                    Text(option.rawValue).tag(GenderOption?.some(option))
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var zodiacStep: some View {
        onboardingCard(symbol: "zodiac", title: "Zodiac Sign", subtitle: "Used as one signal in the prediction engine.") {
            Picker("Zodiac", selection: $viewModel.profile.zodiacSign) {
                ForEach(ZodiacSign.allCases) { sign in
                    Text(sign.rawValue).tag(sign)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxHeight: 180)
        }
    }

    private var favoriteStep: some View {
        onboardingCard(symbol: "number.circle.fill", title: "Favorite Numbers", subtitle: "Add numbers from 1 to 99 separated by commas.") {
            TextField("7, 11, 21", text: $viewModel.favoriteNumberText)
                .keyboardType(.numbersAndPunctuation)
                .padding(14)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.white)
            Text("Detected: \(viewModel.favoriteNumbers.map(String.init).joined(separator: ", "))")
                .font(.footnote)
                .foregroundStyle(AppTheme.textMuted)
        }
    }

    private func onboardingCard<Content: View>(symbol: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: symbol)
                    .font(.system(size: 72, weight: .bold))
                    .foregroundStyle(AppTheme.premiumGradient)
                    .frame(height: 96)
                SectionTitle(title, subtitle: subtitle)
                GlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        content()
                    }
                    .tint(AppTheme.gold)
                }
            }
            .padding()
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
        }
    }
}
