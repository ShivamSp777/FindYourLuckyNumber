import CoreData
import SwiftUI

@main
struct FindYourLuckyNumberApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(
                container: AppContainer(
                    profileRepository: UserDefaultsUserProfileRepository(),
                    historyRepository: CoreDataPredictionHistoryRepository(context: persistenceController.container.viewContext)
                )
            )
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
