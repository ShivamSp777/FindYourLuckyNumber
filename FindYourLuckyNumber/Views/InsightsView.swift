import Charts
import SwiftUI

struct InsightsView: View {
    @StateObject var viewModel: InsightsViewModel

    var body: some View {
        AppBackground {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        summaryGrid
                        frequentNumbers
                        numerology
                        badges
                    }
                    .padding()
                }
                .navigationTitle("Insights")
                .onAppear { viewModel.reload() }
            }
        }
    }

    private var summaryGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
            MetricPill(title: "Streak", value: "\(viewModel.summary.streak) days", systemImage: "flame.fill")
            MetricPill(title: "Points", value: "\(viewModel.summary.rewardPoints)", systemImage: "star.circle.fill")
            MetricPill(title: "Avg Confidence", value: "\(Int(viewModel.summary.averageConfidence * 100))%", systemImage: "gauge.high")
            MetricPill(title: "This Month", value: "\(viewModel.summary.monthlyCount)", systemImage: "calendar.badge.clock")
        }
    }

    private var frequentNumbers: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle("Most Frequent", subtitle: "Numbers appearing most often in your archive.")
                Chart(viewModel.summary.mostFrequentNumbers, id: \.self) { number in
                    SectorMark(angle: .value("Number", 1), innerRadius: .ratio(0.56))
                        .foregroundStyle(by: .value("Number", "\(number)"))
                }
                .frame(height: 190)
                HStack {
                    ForEach(viewModel.summary.mostFrequentNumbers, id: \.self) { number in
                        Text("\(number)")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                            .background(AppTheme.gold, in: Circle())
                    }
                }
            }
        }
    }

    private var numerology: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Numerology", subtitle: "Core calculations from your profile.")
                ForEach(viewModel.numerologyResults) { result in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(result.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("\(result.number)")
                                .font(.title3.weight(.black))
                                .foregroundStyle(AppTheme.gold)
                        }
                        Text(result.explanation)
                            .font(.caption)
                            .foregroundStyle(AppTheme.textMuted)
                        Text(result.steps.joined(separator: " • "))
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.55))
                    }
                    Divider().overlay(.white.opacity(0.12))
                }
            }
        }
    }

    private var badges: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle("Achievements", subtitle: "Progress and accuracy rewards.")
                ForEach(viewModel.summary.badges) { badge in
                    HStack {
                        Image(systemName: badge.isUnlocked ? "checkmark.seal.fill" : "seal")
                            .foregroundStyle(badge.isUnlocked ? AppTheme.gold : AppTheme.textMuted)
                        VStack(alignment: .leading) {
                            Text(badge.title).foregroundStyle(.white).font(.headline)
                            Text(badge.description).foregroundStyle(AppTheme.textMuted).font(.caption)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
