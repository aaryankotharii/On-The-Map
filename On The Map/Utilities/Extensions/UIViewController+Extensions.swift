//
//  UIViewController+Extensions.swift
//  On The Map
//
//  Created by Aaryan Kothari on 07/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import SafariServices

//MARK:-  For LocationVC and LinkVC
extension UIViewController{
    func setupCancelButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }
    @objc func cancelTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    

    func presentSafari(_ mediaUrl : String){
        if let url = URL(string: mediaUrl) {
            if url.isValid{ /// Check Valid URL
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true) /// Present safariVC
            }else{
                AuthAlert("The User did not sumbit a valid URL. Try another one maybe?")
            }
        }
    }
}
