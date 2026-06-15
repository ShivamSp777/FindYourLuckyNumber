import Charts
import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel

    var body: some View {
        AppBackground {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        controls
                        chart
                        ForEach(viewModel.filteredEntries) { entry in
                            historyRow(entry)
                        }
                    }
                    .padding()
                }
                .navigationTitle("History")
                .searchable(text: $viewModel.searchText, prompt: "Search number or color")
                .onAppear { viewModel.reload() }
            }
        }
    }

    private var controls: some View {
        GlassCard {
            Picker("Month", selection: $viewModel.selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                }
            }
            .pickerStyle(.menu)
            .tint(AppTheme.gold)
        }
    }

    private var chart: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle("Trend", subtitle: "Lucky numbers archived this month.")
                Chart(viewModel.filteredEntries) { entry in
                    BarMark(
                        x: .value("Date", entry.prediction.date, unit: .day),
                        y: .value("Lucky Number", entry.prediction.primaryLuckyNumber)
                    )
                    .foregroundStyle(AppTheme.gold)
                }
                .frame(height: 180)
                .chartYAxis { AxisMarks(position: .leading) }
            }
        }
    }

    private func historyRow(_ entry: HistoryEntry) -> some View {
        GlassCard {
            HStack(spacing: 14) {
                Text("\(entry.prediction.primaryLuckyNumber)")
                    .font(.title.weight(.black))
                    .foregroundStyle(AppTheme.gold)
                    .frame(width: 58)
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.prediction.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("\(entry.prediction.luckyColor) • \(Int(entry.prediction.confidenceScore * 100))% confidence")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textMuted)
                }
                Spacer()
            }
        }
    }
}
