//
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import Foundation
import CoreGraphics

/// Utility to convert structured barcode data into drawable objects.
enum BarcodeDrawing {
    /// Creates a **unit** (i.e. not scaled for display) path of a bar code. Because this uses a unit module width and height of 1,
    /// it can be scaled in both the x and y directions for display.
    static func unitPathForModules(_ modules: [BarcodeModule]) -> CGPath {
        var path = CGMutablePath()
        var xPos = 0

        for module in modules {
            defer {
                xPos += module.length
            }

            guard module.type == .bar else {
                continue
            }

            path.addRect(CGRect(x: CGFloat(xPos),
                                y: 0,
                                width: CGFloat(module.length),
                                height: 1))
        }

        return path.copy() ?? CGPath(rect: .zero, transform: nil)
    }
}
