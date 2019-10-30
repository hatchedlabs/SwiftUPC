//
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import XCTest
@testable import SwiftUPC

class upcTests: XCTestCase {
    func testDigitsParseFromString() throws {
        let tests: [(string: String, digits: [Int])] = [
            ("1", [1]),
            ("1234", [1, 2, 3, 4]),
            ("90021268", [9, 0, 0, 2, 1, 2, 6, 8]),
            ("0123456789", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
            ("", [])
        ]

        for (string, expectedDigits) in tests {
            XCTAssertEqual(try UPCABarcodeGenerator.digits(from: string), expectedDigits)
        }
    }

    func testDigitsErrorsOnInvalidInput() {
        let tests: [String] = [
            "-1",
            "l0l",
            "👋",
            " ",
            "cory"
        ]

        for string in tests {
            XCTAssertThrowsError(try UPCABarcodeGenerator.digits(from: string)) { error in
                guard
                    case BarcodeGeneratorError.inputIsNotNumeric(let errorString) = error,
                    errorString == string
                else {
                    XCTFail("Expected BarcodeGeneratorError.inputIsNotNumeric(\(string)) to be thrown")
                    return
                }
            }
        }
    }

    func testLengthVerificationFailures() {
        let invalidLengths: [[Int]] = [
            [],
            [0],
            [9, 9, 9, 9, 9],
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3],
        ]

        for invalidLength in invalidLengths {
            XCTAssertThrowsError(try UPCABarcodeGenerator.verifyCode(invalidLength)) { error in
                guard
                    case BarcodeGeneratorError.incorrectLength(let errorCode) = error,
                    errorCode == invalidLength
                else {
                    XCTFail("Expected BarcodeGeneratorError.incorrectLength(\(invalidLength)) to be thrown")
                    return
                }
            }
        }
    }

    func testValueVerificationFailures() {
        let invalidDigits: [[Int]] = [
            [0, 1, 2, 10, 1, 2, 3, 4, 5, 6, 7, 8],
            [1, -1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [900, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 011]
        ]

        for invalidDigit in invalidDigits {
            XCTAssertThrowsError(try UPCABarcodeGenerator.verifyCode(invalidDigit)) { error in
                guard
                    case BarcodeGeneratorError.invalidValue(let errorCode) = error,
                    errorCode == invalidDigit
                else {
                    XCTFail("Expected BarcodeGeneratorError.invalidValue(\(invalidDigit)) to be thrown")
                    return
                }
            }
        }
    }

    func testCheckDigitVerificationFailures() {
        let invalidCheckDigits: [[Int]] = [
            [4, 3, 4, 3, 3, 1, 4, 7, 0, 1, 1, 6],
            [4, 7, 4, 0, 0, 3, 0, 5, 9, 1, 1, 1]
        ]

        for invalidCheckDigit in invalidCheckDigits {
            XCTAssertThrowsError(try UPCABarcodeGenerator.verifyCode(invalidCheckDigit)) { error in
                guard
                    case BarcodeGeneratorError.invalidCheckDigit(let errorCode) = error,
                    errorCode == invalidCheckDigit
                else {
                    XCTFail("Expected BarcodeGeneratorError.invalidCheckDigit(\(invalidCheckDigit)) to be thrown")
                    return
                }
            }
        }
    }

    func testValidCodeVerification() {
        let validCodes: [[Int]] = [
            [4, 3, 4, 3, 3, 1, 4, 7, 0, 1, 1, 7],
            [4, 7, 4, 0, 0, 3, 0, 5, 9, 1, 1, 0]
        ]

        for validCode in validCodes {
            XCTAssertNoThrow(try UPCABarcodeGenerator.verifyCode(validCode))
        }
    }

    func testOddParityEncoding() {
        let encodings: [(digit: Int, encoding: [BarcodeModule])] = [
            (0, [.space(3), .bar(2), .space, .bar]),
            (1, [.space(2), .bar(2), .space(2), .bar]),
            (2, [.space(2), .bar, .space(2), .bar(2)]),
            (3, [.space, .bar(4), .space, .bar]),
            (4, [.space, .bar, .space(3), .bar(2)]),
            (5, [.space, .bar(2), .space(3), .bar]),
            (6, [.space, .bar, .space, .bar(4)]),
            (7, [.space, .bar(3), .space, .bar(2)]),
            (8, [.space, .bar(2), .space, .bar(3)]),
            (9, [.space(3), .bar, .space, .bar(2)])
        ]

        for encoding in encodings {
            let encodedModules = UPCABarcodeGenerator.encoding(for: encoding.digit, withParity: .odd)
            XCTAssertEqual(encodedModules.moduleCount, 7)
            XCTAssertTrue(encodedModules.hasNoRepeatingSpanTypes)
            XCTAssertEqual(encoding.encoding, encodedModules)
        }
    }

    func testEvenParityEncoding() {
        let encodings: [(digit: Int, encoding: [BarcodeModule])] = [
            (0, [.bar(3), .space(2), .bar, .space]),
            (1, [.bar(2), .space(2), .bar(2), .space]),
            (2, [.bar(2), .space, .bar(2), .space(2)]),
            (3, [.bar, .space(4), .bar, .space]),
            (4, [.bar, .space, .bar(3), .space(2)]),
            (5, [.bar, .space(2), .bar(3), .space]),
            (6, [.bar, .space, .bar, .space(4)]),
            (7, [.bar, .space(3), .bar, .space(2)]),
            (8, [.bar, .space(2), .bar, .space(3)]),
            (9, [.bar(3), .space, .bar, .space(2)])
        ]

        for encoding in encodings {
            let encodedModules = UPCABarcodeGenerator.encoding(for: encoding.digit, withParity: .even)
            XCTAssertEqual(encodedModules.moduleCount, 7)
            XCTAssertTrue(encodedModules.hasNoRepeatingSpanTypes)
            XCTAssertEqual(encoding.encoding, encodedModules)
        }
    }

    func testModuleConsolidation() {
        XCTAssertEqual([.bar, .bar, .bar(3), .space(4), .space(1)].consolidatingModules, [.bar(5), .space(5)])
        XCTAssertEqual([.space(5), .space, .bar(2), .space].consolidatingModules, [.space(6), .bar(2), .space])
        XCTAssertEqual([.space, .space, .space, .space].consolidatingModules, [.space(4)])
        XCTAssertEqual([.bar, .space, .bar, .space, .bar, .bar].consolidatingModules, [.bar, .space, .bar, .space, .bar(2)])
    }
}

private extension Array where Element == BarcodeModule {
    /// Sums the total length of all contained modules.
    var moduleCount: Int {
        return self.reduce(0, { $0 + $1.length })
    }

    /// Returns true if there are no consecutively repeating span types.
    var hasNoRepeatingSpanTypes: Bool {
        for i in 0 ..< (self.count - 1) {
            guard self[i].type != self[i + 1].type else { return false }
        }

        return true
    }
}
