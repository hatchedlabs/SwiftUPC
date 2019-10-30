//
//  UPCABarcodeView.swift
//  upc
//
//  Created by Cory Juhlin on 10/28/19.
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import Foundation
import UIKit

/// Displays a UPC-A barcode in its bounds. The displayed barcode will always fill this view.
final public class UPCABarcodeView: UIView {
    private var shapeLayer: CAShapeLayer { self.layer as! CAShapeLayer }
    private var lastLayerBounds: CGRect = .zero
    private var unitPath: CGPath?

    // Sublayers don't automatically adjust with view bounds changes, but the backing layer does :)
    override public class var layerClass: AnyClass { CAShapeLayer.self }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        shapeLayer.fillColor = UIColor.black.cgColor
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        // Small optimization to prevent recalculating the transform if the layer's bounds haven't changed
        guard layer.bounds != lastLayerBounds else {
            return
        }

        updateScaling()
    }

    /// Structured barcode data to display in the view. An empty array clears any displayed barcode.
    /// Note that this data is not validated.
    public var barcodeModules: [BarcodeModule] = [] {
        didSet {
            guard !barcodeModules.isEmpty else {
                self.shapeLayer.path = nil
                self.unitPath = nil
                return
            }

            let unitPath = BarcodeDrawing.unitPathForModules(self.barcodeModules)
            self.unitPath = unitPath
            updateScaling()
        }
    }

    private func updateScaling() {
        guard let unitPath = self.unitPath else {
            return
        }

        // Want to calculate the x and y scaling values to make the unit width/height barcode path
        // scale to fill the layer's bounds
        self.lastLayerBounds = layer.bounds
        // Empty space is significant in bar codes, so the x-offset should be preserved on both sides
        let xScale = layer.bounds.width / (unitPath.boundingBox.width + (unitPath.boundingBox.origin.x * 2))
        let yScale = layer.bounds.height / unitPath.boundingBox.height
        var transform = CGAffineTransform(scaleX: xScale, y: yScale)

        // It's not clear how this operation can fail, but here we are 🤷‍♀️
        guard let transformedPath = unitPath.copy(using: &transform) else {
            return
        }

        self.shapeLayer.path = transformedPath
    }
}
