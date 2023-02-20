//
//  UIAlertControllerExtension.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 20.02.2023.
//

import UIKit

extension UIAlertController {
    
    static func error(text: String, continueAction: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in
                    alertController.dismiss(animated: true)
                }
            )
        )
        
        return alertController
    }
}
