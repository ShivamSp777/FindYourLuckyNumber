import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var showDeleteConfirmation = false

    var body: some View {
        AppBackground {
            NavigationStack {
                Form {
                    Section("Personal") {
                        TextField("Name", text: $viewModel.profile.name)
                        DatePicker("Birth Date", selection: $viewModel.profile.birthDate, displayedComponents: .date)
                        Picker("Zodiac", selection: $viewModel.profile.zodiacSign) {
                            ForEach(ZodiacSign.allCases) { sign in
                                Text(sign.rawValue).tag(sign)
                            }
                        }
                        Picker("Gender", selection: $viewModel.profile.gender) {
                            Text("Not set").tag(GenderOption?.none)
                            ForEach(GenderOption.allCases) { option in
                                Text(option.rawValue).tag(GenderOption?.some(option))
                            }
                        }
                    }

                    Section("Preferences") {
                        Toggle("Daily Notifications", isOn: Binding(
                            get: { viewModel.profile.notificationsEnabled },
                            set: { viewModel.toggleNotifications($0) }
                        ))
                        HStack {
                            Text("Plan")
                            Spacer()
                            Text(viewModel.profile.premiumPlan.rawValue)
                                .foregroundStyle(AppTheme.gold)
                        }
                    }

                    Section("Data") {
                        Button("Save Changes") { viewModel.save() }
                        Button("Export History") { viewModel.exportHistory() }
                        if !viewModel.exportText.isEmpty {
                            Text(viewModel.exportText)
                                .font(.caption)
                                .textSelection(.enabled)
                        }
                        Button("Delete Data", role: .destructive) { showDeleteConfirmation = true }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Profile")
                .confirmationDialog("Delete all local profile and history data?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                    Button("Delete Data", role: .destructive) { viewModel.deleteAllData() }
                }
            }
        }
    }
}
