//
//  UIViewController+Extensions.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String? = nil, okActionHandler: ((UIAlertAction) -> Void)? = nil) {
        guard let navigationController = navigationController else { return }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okActionHandler)
        alertController.addAction(okAction)
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
