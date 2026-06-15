import Combine
import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var entries: [HistoryEntry] = []
    @Published var searchText = ""
    @Published var selectedMonth = Calendar.current.component(.month, from: Date())

    private let repository: PredictionHistoryRepository

    init(repository: PredictionHistoryRepository) {
        self.repository = repository
        reload()
    }

    var filteredEntries: [HistoryEntry] {
        entries.filter { entry in
            let monthMatches = Calendar.current.component(.month, from: entry.prediction.date) == selectedMonth
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let searchMatches = query.isEmpty || entry.prediction.luckyColor.lowercased().contains(query) || String(entry.prediction.primaryLuckyNumber).contains(query)
            return monthMatches && searchMatches
        }
    }

    func reload() {
        entries = (try? repository.fetchHistory()) ?? []
    }

    func update(_ entry: HistoryEntry) {
        try? repository.update(entry)
        reload()
    }
}
