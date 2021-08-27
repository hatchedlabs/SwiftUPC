//
//  SwiftUIUPC.swift
//  SwiftUPC_Example
//
//  Created by Andrew HunzekerHesed on 8/26/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUPC

// This is just a test of the SwiftUI View.  Not actually used in the example app
struct SwiftUIUPC: View {
    var body: some View {
        UPCAView(upc: "474003059110").frame(width: 160, height: 100, alignment: .center)
    }
}

struct SwiftUIUPC_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIUPC()
    }
}
