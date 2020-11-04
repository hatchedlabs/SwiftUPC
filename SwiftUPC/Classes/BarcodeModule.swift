//
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import Foundation

/// A "module" in a barcode is a region of empty space or a bar with an associated length indicating how
/// many atomic width units the module spans.
public struct BarcodeModule: Equatable {
    enum ModuleType {
        case space
        case bar
    }

    var type: ModuleType

    @GreaterThan(0)
    var length: Int = 1

    /// Flips a region's `type` while maintaining its length.
    var flipped: BarcodeModule {
        let type: ModuleType = self.type == .space ? .bar : .space
        return BarcodeModule(type: type, length: self.length)
    }

    static func space(_ length: Int) -> BarcodeModule {
        return BarcodeModule(type: .space, length: length)
    }

    static func bar(_ length: Int) -> BarcodeModule {
        return BarcodeModule(type: .bar, length: length)
    }

    static let space = BarcodeModule(type: .space)
    static let bar = BarcodeModule(type: .bar)
}

extension Array where Element == BarcodeModule {
    /// Consolidates modules such that adjacent modules of the same `type` are merged together by adding
    /// their lengths.
    public var consolidatingModules: Self {
        self.reduce(into: [BarcodeModule]()) { (result: inout [BarcodeModule], next: BarcodeModule) in
            guard
                let last = result.last,
                last.type == next.type
            else {
                result.append(next)
                return
            }

            result[result.count - 1].length += next.length
        }
    }
}

@propertyWrapper
struct GreaterThan<Wrapped>: Equatable where Wrapped: Comparable {
    private let min: Wrapped
    private var value: Wrapped

    var wrappedValue: Wrapped {
        get { value }
        set { value = self.wrap(newValue) }
    }

    private func wrap(_ value: Wrapped) -> Wrapped {
        Swift.max(value, self.min)
    }

    init(wrappedValue: Wrapped, _ min: Wrapped) {
        self.value = wrappedValue
        self.min = min
        self.value = wrap(wrappedValue)
    }
}
