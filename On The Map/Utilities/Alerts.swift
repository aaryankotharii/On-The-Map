//
//  Alerts.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

extension UIViewController {
    internal func AuthAlert(_ message:String){
        let alert = UIAlertController(title: "Uh Oh 🙁", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
