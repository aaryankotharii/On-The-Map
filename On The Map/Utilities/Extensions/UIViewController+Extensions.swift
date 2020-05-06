//
//  UIViewController+Extensions.swift
//  On The Map
//
//  Created by Aaryan Kothari on 07/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

//MARK:- NavBar for LocationVC and LinkVC
extension UIViewController{
    func setupCancelButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }
    @objc func cancelTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
