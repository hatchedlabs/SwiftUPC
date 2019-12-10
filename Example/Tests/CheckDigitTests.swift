//
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import XCTest
@testable import SwiftUPC

class CheckDigitTests: XCTestCase {
    func testCheckDigitCalculation() {
        let codes: [(code: [Int], expectedCheckDigit: Int)] = [
            ([1, 7, 8, 9, 0], 7),
            ([0], 0),
            ([], 0),
            ([1, 2, 3], 6),
            ([0, 0, 7, 5], 4),
            ([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], 5)
        ]

        for (code, expectedCheckDigit) in codes {
            XCTAssertEqual(expectedCheckDigit, UPCABarcodeGenerator.calculateCheckDigit(from: code))
        }
    }
}
