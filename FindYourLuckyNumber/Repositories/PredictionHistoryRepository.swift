import CoreData
import Foundation

@MainActor
protocol PredictionHistoryRepository {
    func fetchHistory() throws -> [HistoryEntry]
    func save(_ prediction: DailyPrediction) throws
    func update(_ entry: HistoryEntry) throws
    func delete(_ entry: HistoryEntry) throws
    func deleteAll() throws
}

@MainActor
final class CoreDataPredictionHistoryRepository: PredictionHistoryRepository {
    private let context: NSManagedObjectContext
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchHistory() throws -> [HistoryEntry] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "PredictionRecord")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try context.fetch(request).compactMap(mapRecord)
    }

    func save(_ prediction: DailyPrediction) throws {
        let existing = try record(for: prediction.date)
        let record = existing ?? NSManagedObject(entity: entityDescription(), insertInto: context)
        record.setValue(existing?.value(forKey: "id") as? UUID ?? UUID(), forKey: "id")
        apply(prediction: prediction, note: existing?.value(forKey: "note") as? String ?? "", feedback: existing?.value(forKey: "userFeedback") as? String ?? "", accuracy: existing?.value(forKey: "accuracy") as? Double ?? 0, to: record)
        try context.save()
    }

    func update(_ entry: HistoryEntry) throws {
        guard let record = try record(id: entry.id) else { return }
        apply(prediction: entry.prediction, note: entry.note, feedback: entry.userFeedback, accuracy: entry.accuracy, to: record)
        record.setValue(entry.createdAt, forKey: "createdAt")
        try context.save()
    }

    func delete(_ entry: HistoryEntry) throws {
        guard let record = try record(id: entry.id) else { return }
        context.delete(record)
        try context.save()
    }

    func deleteAll() throws {
        for entry in try fetchRecords() {
            context.delete(entry)
        }
        try context.save()
    }

    private func fetchRecords() throws -> [NSManagedObject] {
        try context.fetch(NSFetchRequest<NSManagedObject>(entityName: "PredictionRecord"))
    }

    private func record(id: UUID) throws -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "PredictionRecord")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func record(for date: Date) throws -> NSManagedObject? {
        let day = Calendar.current.startOfDay(for: date)
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: day) else { return nil }
        let request = NSFetchRequest<NSManagedObject>(entityName: "PredictionRecord")
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", day as NSDate, nextDay as NSDate)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func entityDescription() -> NSEntityDescription {
        guard let entity = NSEntityDescription.entity(forEntityName: "PredictionRecord", in: context) else {
            fatalError("PredictionRecord entity is missing from the Core Data model.")
        }
        return entity
    }

    private func apply(prediction: DailyPrediction, note: String, feedback: String, accuracy: Double, to record: NSManagedObject) {
        record.setValue(prediction.date, forKey: "date")
        record.setValue(Int64(prediction.primaryLuckyNumber), forKey: "primaryLuckyNumber")
        record.setValue(encodedString(prediction.secondaryLuckyNumbers), forKey: "secondaryNumbersData")
        record.setValue(prediction.confidenceScore, forKey: "confidence")
        record.setValue(prediction.luckyColor, forKey: "luckyColor")
        record.setValue(prediction.luckyDirection, forKey: "luckyDirection")
        record.setValue(prediction.luckyTime, forKey: "luckyTime")
        record.setValue(encodedString(prediction.categories), forKey: "categoriesData")
        record.setValue(note, forKey: "note")
        record.setValue(feedback, forKey: "userFeedback")
        record.setValue(accuracy, forKey: "accuracy")
        record.setValue(record.value(forKey: "createdAt") as? Date ?? Date(), forKey: "createdAt")
    }

    private func mapRecord(_ record: NSManagedObject) -> HistoryEntry? {
        guard let id = record.value(forKey: "id") as? UUID,
              let date = record.value(forKey: "date") as? Date else { return nil }

        let secondary: [Int] = decodedString(record.value(forKey: "secondaryNumbersData") as? String) ?? []
        let categories: [CategoryPrediction] = decodedString(record.value(forKey: "categoriesData") as? String) ?? []
        let primary = (record.value(forKey: "primaryLuckyNumber") as? Int64).map(Int.init) ?? 1
        let prediction = DailyPrediction(
            id: id,
            date: date,
            primaryLuckyNumber: primary,
            secondaryLuckyNumbers: secondary,
            confidenceScore: record.value(forKey: "confidence") as? Double ?? 0,
            luckyColor: record.value(forKey: "luckyColor") as? String ?? "Gold",
            luckyDirection: record.value(forKey: "luckyDirection") as? String ?? "East",
            luckyTime: record.value(forKey: "luckyTime") as? String ?? "09:00 AM",
            categories: categories
        )
        return HistoryEntry(
            id: id,
            prediction: prediction,
            note: record.value(forKey: "note") as? String ?? "",
            userFeedback: record.value(forKey: "userFeedback") as? String ?? "",
            accuracy: record.value(forKey: "accuracy") as? Double ?? 0,
            createdAt: record.value(forKey: "createdAt") as? Date ?? date
        )
    }

    private func encodedString<T: Encodable>(_ value: T) -> String {
        guard let data = try? encoder.encode(value) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }

    private func decodedString<T: Decodable>(_ value: String?) -> T? {
        guard let value, let data = value.data(using: .utf8) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
