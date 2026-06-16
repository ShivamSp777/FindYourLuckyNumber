//
//  LuckyResultView.swift
//  MyLuckyNumber
//
//  Created by Shivam Kumar Pandey on 12/06/26.
//

import SwiftUI
import SwiftData

struct LuckyResultView: View {

    let luckyNumber: Int

    @Query(sort: \LuckyNumberRecord.calculationDate, order: .reverse)
    private var savedResults: [LuckyNumberRecord]
    @State private var showPastResults = false

    var body: some View {

        let info = luckyInfo(for: luckyNumber)

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

                    Text("Your Lucky Result")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    LuckyNumberCircleView(
                        luckyNumber: luckyNumber
                    )

                    ResultSection(
                        info: info
                    )

                    Button {
                        showPastResults = true
                    } label: {
                        Label(
                            "Past Results",
                            systemImage: "clock.arrow.circlepath"
                        )
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white.opacity(0.12))
                        .foregroundColor(.yellow)
                        .cornerRadius(20)
                    }

                    Button {

                    } label: {

                        Label(
                            "Share Result",
                            systemImage: "square.and.arrow.up"
                        )
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    .yellow,
                                    .orange
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.black)
                        .cornerRadius(20)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showPastResults) {
            PastLuckyResultsView(
                records: savedResults
            )
        }
    }

    func luckyInfo(for number: Int) -> LuckyInfo {

        switch number {

        case 1:
            return LuckyInfo(
                title: "Leader",
                description: "Strong, independent and ambitious.",
                luckyColor: "Red",
                luckyDay: "Sunday"
            )

        case 2:
            return LuckyInfo(
                title: "Peacemaker",
                description: "Cooperative and caring.",
                luckyColor: "White",
                luckyDay: "Monday"
            )

        case 7:
            return LuckyInfo(
                title: "Thinker",
                description: "Wise, analytical and spiritual.",
                luckyColor: "Purple",
                luckyDay: "Thursday"
            )

        default:
            return LuckyInfo(
                title: "Lucky Soul",
                description: "Positive energy surrounds you.",
                luckyColor: "Gold",
                luckyDay: "Sunday"
            )
        }
    }
}

struct LuckyNumberCircleView: View {

    let luckyNumber: Int

    @State private var progress: CGFloat = 0

    var body: some View {

        ZStack {

            Circle()
                .stroke(
                    Color.white.opacity(0.15),
                    lineWidth: 18
                )

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            .yellow,
                            .orange,
                            .yellow
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 18,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 8) {

                Text("🍀")
                    .font(.largeTitle)

                Text("\(luckyNumber)")
                    .font(.system(size: 70))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 250, height: 250)
        .onAppear {

            withAnimation(
                .easeOut(duration: 1.5)
            ) {
                progress = 1
            }
        }
    }
}

struct ResultSection: View {

    let info: LuckyInfo

    var body: some View {

        VStack(spacing: 20) {

            Text(info.title)
                .font(.title)
                .bold()
                .foregroundColor(.white)

            Text(info.description)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))

            Divider()
                .background(.white)

            HStack {

                Label(
                    info.luckyColor,
                    systemImage: "paintpalette.fill"
                )

                Spacer()

                Label(
                    info.luckyDay,
                    systemImage: "calendar"
                )
            }
            .foregroundColor(.yellow)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.opacity(0.08))
        )
    }
}

struct PastLuckyResultsView: View {

    let records: [LuckyNumberRecord]

    var body: some View {

        NavigationStack {
            Group {
                if records.isEmpty {
                    ContentUnavailableView(
                        "No Past Results",
                        systemImage: "clock",
                        description: Text("Your generated lucky numbers will appear here.")
                    )
                } else {
                    List(records) { record in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(record.name)
                                    .font(.headline)

                                Spacer()

                                Text("Lucky Number: \(record.luckyNumber)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }

                            Text("DOB: \(record.birthDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text("Date: \(record.calculationDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Past Results")
        }
    }
}
