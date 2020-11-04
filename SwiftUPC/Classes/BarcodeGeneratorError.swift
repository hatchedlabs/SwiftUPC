//
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import Foundation

/// Indicates errors that occur when parsing barcode data from a string.
public enum BarcodeGeneratorError: LocalizedError {
    case inputIsNotNumeric(String)
    case incorrectLength([Int])
    case invalidValue([Int])
    case invalidCheckDigit([Int])

    public var errorDescription: String? {
        switch self {
        case .inputIsNotNumeric(let inputString):
            return "Input string \"\(inputString)\" is not numeric."
        case .incorrectLength(let digits):
            return "Input \(digits) should have a length of 12."
        case .invalidValue(let digits):
            return "Input \(digits) contains an invalid value. Values should range from 0 to 9."
        case .invalidCheckDigit(let digits):
            return "Check digit is incorrect for code \(digits)."
        }
    }
}
