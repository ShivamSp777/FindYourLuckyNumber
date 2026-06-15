import SwiftUI

struct MainTabView: View {
    let container: AppContainer
    @ObservedObject var appViewModel: AppViewModel
    let profile: UserProfile

    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel(profile: profile, historyRepository: container.historyRepository, predictionEngine: container.predictionEngine))
                .tabItem { Label("Home", systemImage: "house.fill") }
            DailyPredictionView(viewModel: DailyPredictionViewModel(profile: profile, historyRepository: container.historyRepository, predictionEngine: container.predictionEngine))
                .tabItem { Label("Daily", systemImage: "sun.max.fill") }
            HistoryView(viewModel: HistoryViewModel(repository: container.historyRepository))
                .tabItem { Label("History", systemImage: "calendar") }
            InsightsView(viewModel: InsightsViewModel(profile: profile, historyRepository: container.historyRepository, calculator: container.numerologyCalculator))
                .tabItem { Label("Insights", systemImage: "chart.bar.xaxis") }
            ProfileView(viewModel: ProfileViewModel(profile: profile, appViewModel: appViewModel, historyRepository: container.historyRepository, notificationManager: container.notificationManager))
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(AppTheme.gold)
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        AppBackground {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 18) {
                        if let prediction = viewModel.prediction {
                            luckyNumberCard(prediction)
                            detailGrid(prediction)
                            secondaryNumbers(prediction.secondaryLuckyNumbers)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Today")
                .toolbar {
                    if viewModel.prediction != nil {
                        ShareLink(item: viewModel.shareText()) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .accessibilityLabel("Share lucky number")
                    }
                }
                .refreshable { await viewModel.refresh() }
                .onAppear { if viewModel.prediction == nil { viewModel.load() } }
            }
            .scrollContentBackground(.hidden)
        }
    }

    private func luckyNumberCard(_ prediction: DailyPrediction) -> some View {
        GlassCard {
            VStack(spacing: 16) {
                Text("Today's Lucky Number")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textMuted)
                Text("\(viewModel.revealedNumber)")
                    .font(.system(size: 86, weight: .black, design: .rounded))
                    .contentTransition(.numericText())
                    .foregroundStyle(AppTheme.premiumGradient)
                    .accessibilityLabel("Lucky number \(prediction.primaryLuckyNumber)")
                ProgressView(value: prediction.confidenceScore)
                    .tint(AppTheme.gold)
                Text("\(Int(prediction.confidenceScore * 100))% confidence")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func detailGrid(_ prediction: DailyPrediction) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
            MetricPill(title: "Lucky Color", value: prediction.luckyColor, systemImage: "paintpalette.fill")
            MetricPill(title: "Direction", value: prediction.luckyDirection, systemImage: "location.north.fill")
            MetricPill(title: "Lucky Time", value: prediction.luckyTime, systemImage: "clock.fill")
            MetricPill(title: "Daily Focus", value: prediction.categories.max(by: { $0.score < $1.score })?.category.rawValue ?? "Love", systemImage: "sparkles")
        }
    }

    private func secondaryNumbers(_ numbers: [Int]) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Secondary Numbers", subtitle: "Use these as supporting signals.")
                HStack {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.black)
                            .frame(width: 54, height: 54)
                            .background(AppTheme.gold, in: Circle())
                    }
                }
            }
        }
    }
}
