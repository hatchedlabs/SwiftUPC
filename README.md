# SwiftUPC
Small, lightweight library for generating UPC-A barcodes from text data. Currently provides utilities for parsing
structured barcode data from a string representation, as well as a custom UIKit view for displaying barcode data.

![SwiftUPC easy UPC-A barcode generation in Swift](https://raw.githubusercontent.com/hatchedlabs/SwiftUPC/readme-screenshot/Assets/demo-screenshot.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
SwiftUPC has no external dependencies except UIKit.

## Installation

SwiftUPC is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftUPC'
```

## Usage
```swift
import SwiftUPC
```

### Parsing Raw String Data
If you have a UPC-A barcode number in `String` format, you can use `UPCABarcodeGenerator.upcaBarcodeModules(from string: String)`
to parse into structured barcode data.

```swift
let barcodeString = "474003059110"
// The below call can throw if parsing fails. See `BarcodeGeneratorError` for more info.
let barcodeModules = try! UPCABarcodeGenerator.upcaBarcodeModules(from: barcodeString)
```

### Displaying a Barcode
Use the custom view  `UPCABarcodeView` to display barcodes in your interface. `UPCABarcodeView` will fill its bounds with the provided
bar code.

```swift
let barcodeView: UPCABarcodeView // initialized somewhere in code, Storyboard, or Xib
barcodeView.barcodeModules = barcodeModules
```

### Check Digit Calculation
Check digits can be calculated for any valid UPC (or EAN13) code:

```swift
let code = [1, 2, 3]
let checkDigit = UPCABarcodeGenerator.calculateCheckDigit(from: code)
```

## Author

[Hatched Labs](https://hatchedlabs.com)

## License

SwiftUPC is available under the MIT license. See the LICENSE file for more info.
