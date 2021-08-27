//
//  UPCAView.swift
//  SwiftUPC_Example
//
//  Created by Andrew HunzekerHesed on 8/26/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import CoreGraphics

/// A Swift UI implementation of the UPCA generator.  Whhen using please remember to set the width at least 50% wider than the
/// height.  (tested against the iphone Scanner app).  YMMV.

public struct UPCAView: View {
    public init(upc: String) {
        self.upc = upc
    }

    public let upc: String

    private var modules: [BarcodeModule]? {
        try? UPCABarcodeGenerator.upcaBarcodeModules(from: upc)
    }

    private var unitPath: CGPath {
        BarcodeDrawing.unitPathForModules(modules ?? [])
    }

    private func updateScaling(_ size: CGSize) -> CGPath {
        let xScale = size.width / (unitPath.boundingBox.width + (unitPath.boundingBox.origin.x * 2))
        let yScale = size.height / unitPath.boundingBox.height
        var transform = CGAffineTransform(scaleX: xScale, y: yScale)

        guard let transformedPath = unitPath.copy(using: &transform) else {
            return unitPath
        }
        return transformedPath
    }

    public var body: some View {
        GeometryReader { geometry in
            Path(updateScaling(geometry.size))
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(8.0)
        }
    }
}

struct UPCAView_Previews: PreviewProvider {
    static var previews: some View {
        UPCAView(upc: "474003059110").frame(width: 160, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

    }
}
