//
//  Copyright © 2021 Hatched Labs. All rights reserved.
//

import SwiftUI
import SwiftUPC

//// This is just a test of the SwiftUI View.  Not actually used in the example app
struct SwiftUIUPCA: View {
    private var dataModel = UPCAData()
    
    var body: some View {
        UPCAView(dataModel: dataModel)
            .frame(width: 160, height: 100, alignment: .center)
            .onAppear {
                do {
                    try dataModel.generateCode(code: "474003059110")
                } catch {
                    print("Swift UI Error: \(error)")
                }
            }
    }
}

struct SwiftUIUPCA_Previews: PreviewProvider {
    
    static var previews: some View {
        SwiftUIUPCA()
    }
}
