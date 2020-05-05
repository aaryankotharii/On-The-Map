//
//  SignUpViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 05/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import WebKit

class SignUpViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://auth.udacity.com/sign-up")
        showWebsite(url!)
        // Do any additional setup after loading the view.
    }
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showWebsite(_ url : URL){
                        
        webView.navigationDelegate = self
                        
        webView.load(URLRequest(url: url))
        
        webView.allowsBackForwardNavigationGestures = true
    }
    
    
}
