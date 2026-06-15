import Foundation

struct NumerologyCalculator {
    func calculate(name: String, birthDate: Date) -> [NumerologyResult] {
        [
            lifePathNumber(from: birthDate),
            destinyNumber(from: name),
            soulNumber(from: name),
            personalityNumber(from: name)
        ]
    }

    func lifePathNumber(from birthDate: Date) -> NumerologyResult {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: birthDate)
        let digits = "\(components.day ?? 1)\(components.month ?? 1)\(components.year ?? 2000)".compactMap { $0.wholeNumberValue }
        let number = reduce(digits.reduce(0, +))
        return NumerologyResult(
            title: "Life Path",
            number: number,
            steps: ["Add every digit in the birth date", "Reduce \(digits.reduce(0, +)) to \(number)"],
            explanation: "Life Path highlights the core rhythm and long-term direction of your personal cycle."
        )
    }

    func destinyNumber(from name: String) -> NumerologyResult {
        let value = letterValues(for: name, include: { $0.isLetter }).reduce(0, +)
        let number = reduce(value)
        return NumerologyResult(
            title: "Destiny",
            number: number,
            steps: ["Convert all name letters into numerology values", "Reduce \(value) to \(number)"],
            explanation: "Destiny reflects expression, ambition, and the way your abilities show up publicly."
        )
    }

    func soulNumber(from name: String) -> NumerologyResult {
        let value = letterValues(for: name) { character in
            "AEIOU".contains(character.uppercased())
        }.reduce(0, +)
        let number = reduce(value)
        return NumerologyResult(
            title: "Soul",
            number: number,
            steps: ["Use vowels from the name", "Reduce \(value) to \(number)"],
            explanation: "Soul Number points to inner motivation, emotional preference, and private desire."
        )
    }

    func personalityNumber(from name: String) -> NumerologyResult {
        let value = letterValues(for: name) { character in
            character.isLetter && !"AEIOU".contains(character.uppercased())
        }.reduce(0, +)
        let number = reduce(value)
        return NumerologyResult(
            title: "Personality",
            number: number,
            steps: ["Use consonants from the name", "Reduce \(value) to \(number)"],
            explanation: "Personality Number describes first impressions and outward style."
        )
    }

    func reduce(_ value: Int) -> Int {
        var current = value
        while current > 9, current != 11, current != 22, current != 33 {
            current = String(current).compactMap { $0.wholeNumberValue }.reduce(0, +)
        }
        return max(current, 1)
    }

    private func letterValues(for name: String, include: (Character) -> Bool) -> [Int] {
        name.uppercased().compactMap { character in
            guard include(character), let scalar = character.unicodeScalars.first else { return nil }
            return (Int(scalar.value) - 64 - 1) % 9 + 1
        }
    }
}
