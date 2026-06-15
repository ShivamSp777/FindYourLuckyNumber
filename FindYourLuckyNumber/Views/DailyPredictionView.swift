import SwiftUI

struct DailyPredictionView: View {
    @StateObject var viewModel: DailyPredictionViewModel

    var body: some View {
        AppBackground {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 14) {
                        SectionTitle("Daily Prediction", subtitle: "Category guidance for today.")
                        ForEach(viewModel.prediction.categories) { item in
                            GlassCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Label(item.category.rawValue, systemImage: icon(for: item.category))
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text("\(item.score)")
                                            .font(.title3.weight(.bold))
                                            .foregroundStyle(AppTheme.gold)
                                    }
                                    ProgressView(value: Double(item.score), total: 100)
                                        .tint(AppTheme.gold)
                                    Text(item.prediction)
                                        .font(.body)
                                        .foregroundStyle(.white)
                                    Text(item.recommendation)
                                        .font(.callout)
                                        .foregroundStyle(AppTheme.textMuted)
                                }
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding()
                }
                .navigationTitle("Prediction")
            }
        }
    }

    private func icon(for category: PredictionCategory) -> String {
        switch category {
        case .love: return "heart.fill"
        case .career: return "briefcase.fill"
        case .finance: return "creditcard.fill"
        case .health: return "cross.case.fill"
        case .travel: return "airplane"
        }
    }
}
