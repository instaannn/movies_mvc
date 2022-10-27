// UIViewController+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alercAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(alercAction)
        present(alert, animated: true)
    }
}
