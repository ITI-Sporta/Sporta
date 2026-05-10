//
//  AlertsManager.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import UIKit

class AlertManager {
    
    static func showDeleteConfirmation(
        on vc: UIViewController,
        title: String = "Delete Item?",
        message: String,
        completion: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true)
    }
    
    static func showError(on vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }
}
