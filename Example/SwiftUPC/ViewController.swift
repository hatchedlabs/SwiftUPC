//
//  Copyright © 2019 Hatched Labs. All rights reserved.
//

import Foundation
import UIKit
import SwiftUPC
import SwiftUI

final class DemoController: UIViewController {
    private weak var barcode: UIHostingController<UPCAView>!
    private var barcodeDataModel = UPCAData()
    private weak var textField: UITextField!
    private weak var generateButton: UIButton!
    private weak var errorLabel: UILabel!

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8)
        ])

        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Type a 12-digit UPC-A code"
        textField.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        textField.clearButtonMode = .always
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        stack.addArrangedSubview(textField)
        self.textField = textField

        let barcodeContainer = UIView()
        barcodeContainer.backgroundColor = .secondarySystemBackground
        stack.addArrangedSubview(barcodeContainer)

        let barcode = UIHostingController(rootView: UPCAView(dataModel: barcodeDataModel))
        barcode.view.frame = view.frame
        view.addSubview(barcode.view)
        barcode.didMove(toParent: self)
        barcode.view.translatesAutoresizingMaskIntoConstraints = false
        barcode.view.backgroundColor = .white
        barcodeContainer.addSubview(barcode.view)
        NSLayoutConstraint.activate([
            barcode.view.topAnchor.constraint(equalTo: barcodeContainer.topAnchor, constant: 8),
            barcode.view.leftAnchor.constraint(equalTo: barcodeContainer.leftAnchor, constant: 8),
            barcode.view.rightAnchor.constraint(equalTo: barcodeContainer.rightAnchor, constant: -8),
            barcode.view.bottomAnchor.constraint(equalTo: barcodeContainer.bottomAnchor, constant: -8),
            barcode.view.heightAnchor.constraint(equalToConstant: 100)
        ])
        self.barcode = barcode

        let generateButton = UIButton(type: .custom)
        generateButton.setTitle("Generate Bar Code", for: .normal)
        generateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        generateButton.backgroundColor = .secondarySystemFill
        generateButton.setTitleColor(.label, for: .normal)
        generateButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        stack.addArrangedSubview(generateButton)
        self.generateButton = generateButton

        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .systemRed
        errorLabel.font = UIFont.boldSystemFont(ofSize: 14)
        errorLabel.alpha = 0
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8),
            errorLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            errorLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8)
        ])
        self.errorLabel = errorLabel

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)

        // It's more fun to start with a barcode visible
        let prefillCode = "474003059110"
        textField.text = prefillCode
        displayBarCode(prefillCode)
    }

    private func displayBarCode(_ code: String) {
        do {
            try barcodeDataModel.generateCode(code: code)
        } catch {
            print("Error Display Bar Code: (\(error)")
        }
    }

    @objc private func generateButtonTapped() {
        guard let text = textField.text else {
            return
        }

        displayBarCode(text)
    }

    private func fadeInError(_ error: Error) {
        errorLabel.text = error.localizedDescription

        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.errorLabel.alpha = 1
        })
    }
}
