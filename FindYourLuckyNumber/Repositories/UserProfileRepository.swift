import Foundation

protocol UserProfileRepository {
    func loadProfile() -> UserProfile?
    func saveProfile(_ profile: UserProfile)
    func deleteProfile()
}

final class UserDefaultsUserProfileRepository: UserProfileRepository {
    private let defaults: UserDefaults
    private let key = "user-profile"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadProfile() -> UserProfile? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }

    func saveProfile(_ profile: UserProfile) {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        defaults.set(data, forKey: key)
    }

    func deleteProfile() {
        defaults.removeObject(forKey: key)
    }
}
