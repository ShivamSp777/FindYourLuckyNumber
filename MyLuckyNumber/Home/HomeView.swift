import SwiftUI
import SwiftData


struct HomeView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LuckyNumberRecord.calculationDate, order: .reverse)
    private var savedResults: [LuckyNumberRecord]
    @StateObject private var viewModel = HomeViewModel()

    @State private var isAnimatingLogo = false
    @FocusState private var isNameFocused: Bool

    var body: some View {

        NavigationStack {
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.07, blue: 0.20),
                        Color(red: 0.18, green: 0.10, blue: 0.35)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(spacing: 30) {
                        
                        headerSection
                        
                        nameSection
                        
                        datePickerSection
                        
                        generateButton
                        
                        // resultSection
                    }
                    .padding()
                }
            }
            .navigationDestination(
                item: $viewModel.luckyResult
            ) { result in
                
                LuckyResultView(
                    luckyNumber: result.number
                )
            }
        }
       
        .onAppear {
            isAnimatingLogo = true
            viewModel.setSavedNameIfNeeded(savedResults.first?.name)
        }
    }
}
#Preview {
    HomeView()
}

extension HomeView {

    private var headerSection: some View {

        VStack(spacing: 12) {

            Image(systemName: "sparkles")
                .font(.system(size: 70))
                .foregroundStyle(.yellow)
                .scaleEffect(
                    isAnimatingLogo ? 1.15 : 0.9
                )
                .animation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(),
                    value: isAnimatingLogo
                )

            Text("My Lucky Number")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Discover your lucky number")
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

extension HomeView {

    private var nameBinding: Binding<String> {
        Binding(
            get: {
                viewModel.name
            },
            set: { newName in
                viewModel.updateName(newName)
            }
        )
    }

    private var nameSection: some View {

        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 12) {

                Image(systemName: "person.fill")
                    .foregroundColor(.yellow)

                TextField(
                    "",
                    text: nameBinding,
                    prompt: Text("Enter your name")
                        .foregroundColor(.white.opacity(0.5))
                )
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.12))
            )
            .overlay {
                   RoundedRectangle(cornerRadius: 20)
                       .stroke(
                           borderColor,
                           lineWidth: 2
                       )
               }
               .shadow(
                   color: borderColor.opacity(0.4),
                   radius: isNameFocused ? 8 : 0
               )
               .animation(.easeInOut(duration: 0.2), value: borderColor)
            
            if let validationMessage = viewModel.validationMessage {

                HStack(spacing: 6) {

                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.orange)

                    Text(validationMessage)
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.validationMessage)
    }
    private var borderColor: Color {

        if viewModel.validationMessage != nil {
            return .orange
        }

        return isNameFocused
            ? .yellow
            : .white.opacity(0.3)
    }
}

extension HomeView {

    private var datePickerSection: some View {
        VStack {
            DatePicker(
                "",
                selection: $viewModel.birthDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .colorScheme(.dark)
            .tint(.yellow)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            Color("#4B2E83"),
                            Color("#2D1B55")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.15))
        )
        .shadow(
            color: .yellow.opacity(0.2),
            radius: 10
        )
//        .onChange(of: viewModel.birthDate) { _, _ in
//            viewModel.validateInputs()
//        }
    }
    
}

extension HomeView {

    private var generateButton: some View {

        Button {

            UIImpactFeedbackGenerator(
                style: .medium
            ).impactOccurred()
            
            viewModel.generateLuckyNumber(
                modelContext: modelContext
            )

        } label: {

            HStack {

                Image(systemName: "sparkles")

                Text("Generate Lucky Number")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.yellow, .orange],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.black)
            .cornerRadius(20)
        }
        .disabled(!viewModel.isGenerateEnabled)
        .opacity(
            viewModel.isGenerateEnabled ? 1 : 0.5
        )
    }
}

//extension HomeView {
//
//    @ViewBuilder
//    private var resultSection: some View {
//
//        if viewModel.showResult,
//           let luckyNumber = $viewModel.luckyResult {
//
//            VStack(spacing: 15) {
//
//                Text("🍀")
//                    .font(.system(size: 60))
//
//                Text("Your Lucky Number")
//                    .foregroundColor(.white)
//
//                Text("\(luckyNumber)")
//                    .font(.system(size: 90))
//                    .fontWeight(.heavy)
//                    .foregroundStyle(.yellow)
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(
//                RoundedRectangle(
//                    cornerRadius: 24
//                )
//                .fill(.white.opacity(0.12))
//            )
//        }
//    }
//}

