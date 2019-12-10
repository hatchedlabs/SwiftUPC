//
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import Foundation

/// The parity of an encoded value refers to the number of bar modules used in its encoding. The left half of
/// the bar code is odd parity, while the right half is even.
enum UPCABarcodeParity {
    case odd
    case even
}

/// Utility to generate structured barcode data.
public enum UPCABarcodeGenerator {
    static let quietZone: [BarcodeModule] = [.space(9)]
    static let startEnd: [BarcodeModule] = [.bar, .space, .bar]
    static let middle: [BarcodeModule] = [.space, .bar, .space, .bar, .space]

    /// Generates data suitable for use by `UPCABarcodeView` from a `String` representation of UPC data.
    public static func upcaBarcodeModules(from string: String) throws -> [BarcodeModule] {
        let codeDigits = try digits(from: string)
        try verifyCode(codeDigits)

        var modules: [BarcodeModule] = []
        modules.append(contentsOf: quietZone)
        modules.append(contentsOf: startEnd)
        let leftHalf = codeDigits[0...5].flatMap { encoding(for: $0, withParity: .odd) }
        modules.append(contentsOf: leftHalf)
        modules.append(contentsOf: middle)
        let rightHalf = codeDigits[6...11].flatMap { encoding(for: $0, withParity: .even) }
        modules.append(contentsOf: rightHalf)
        modules.append(contentsOf: startEnd)
        modules.append(contentsOf: quietZone)

        return modules.consolidatingModules
    }

    /// Calculates the check digit for a numeric code of arbitrary length.
    /// - Note: If an empty code is supplied, 0 will be returned.
    public static func calculateCheckDigit<Code>(from code: Code) -> Int where Code: Sequence, Code.Element == Int {
        // Sum up the digits in even/odd positions in the sequence.
        var odds: Int = 0
        var evens: Int = 0
        for (index, codeDigit) in code.enumerated() {
            if (index + 1) % 2 == 0 {
                evens += codeDigit
            } else {
                odds += codeDigit
            }
        }

        let mod10 = ((odds * 3) + evens) % 10
        return (10 - mod10) % 10
    }

    /// Converts a `String` representation of a series of digits into an array of integers.
    static func digits(from string: String) throws -> [Int] {
        return try string.map {
            guard let digit = Int(String($0)) else {
                throw BarcodeGeneratorError.inputIsNotNumeric(string)
            }

            return digit
        }
    }

    /// Verifies that a provided code is valid, i.e, 1) it has 12 digits, 2) all digits range from 0–9, and
    /// 3) the check digit is valid.
    static func verifyCode(_ code: [Int]) throws {
        guard code.count == 12 else {
            throw BarcodeGeneratorError.incorrectLength(code)
        }

        guard code.allSatisfy({ $0 >= 0 && $0 <= 9 }) else {
            throw BarcodeGeneratorError.invalidValue(code)
        }

        let checkDigit = code[11]
        guard checkDigit == calculateCheckDigit(from: code[..<11]) else {
            throw BarcodeGeneratorError.invalidCheckDigit(code)
        }
    }

    /// Generates the modules (i.e. space/bar sequence) to encode the provided digit with odd or even parity.
    /// - Note: Input is assumed to be **valid** and no error checking is performed.
    static func encoding(for codeDigit: Int, withParity parity: UPCABarcodeParity) -> [BarcodeModule] {
        let oddParity: [BarcodeModule]
        switch codeDigit {
        case 0:
            oddParity = [.space(3), .bar(2), .space, .bar]
        case 1:
            oddParity = [.space(2), .bar(2), .space(2), .bar]
        case 2:
            oddParity = [.space(2), .bar, .space(2), .bar(2)]
        case 3:
            oddParity = [.space, .bar(4), .space, .bar]
        case 4:
            oddParity = [.space, .bar, .space(3), .bar(2)]
        case 5:
            oddParity = [.space, .bar(2), .space(3), .bar]
        case 6:
            oddParity = [.space, .bar, .space, .bar(4)]
        case 7:
            oddParity = [.space, .bar(3), .space, .bar(2)]
        case 8:
            oddParity = [.space, .bar(2), .space, .bar(3)]
        case 9:
            oddParity = [.space(3), .bar, .space, .bar(2)]
        default:
            return []
        }

        guard parity == .odd else {
            return oddParity.map { $0.flipped }
        }

        return oddParity
    }
}
