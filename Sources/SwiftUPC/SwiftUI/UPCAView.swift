//
//  Copyright © 2021 Hatched Labs. All rights reserved.
//

import SwiftUI
import Combine
import CoreGraphics

/// A Swift UI implementation of the UPCA generator.  Whhen using please remember to set the width at least 50% wider than the
/// height.  (tested against the iphone Scanner app).  YMMV.

public class UPCAData: ObservableObject {
    private var code: String
    @Published private(set) var barcodeModules: [BarcodeModule]?

    public init() {
        self.code = "" // Init Empty String
    }
    
    public func generateCode(code: String) throws {
        self.code = code
        self.barcodeModules = try UPCABarcodeGenerator.upcaBarcodeModules(from: self.code)
    }
}

public struct UPCAView: View {
    @ObservedObject public var dataModel: UPCAData

    public init(dataModel: UPCAData = UPCAData()) {
        self.dataModel = dataModel
    }

    private var unitPath: CGPath {
        BarcodeDrawing.unitPathForModules(dataModel.barcodeModules ?? [])
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
    static var data = UPCAData()
    
    static var previews: some View {
        UPCAView(dataModel: data)
            .frame(width: 160, height: 100, alignment: .center)
            .onAppear {
                try? data.generateCode(code: "474003059110")
            }

    }
}
