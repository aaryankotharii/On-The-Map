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
    
    //MARK: WebView to display Udacity website
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- webView setup
    func setupWebView(){
        webView.navigationDelegate = self
        let url = URL(string: "https://auth.udacity.com/sign-up")       /// Udacity Signup page url
        webView.load(URLRequest(url: url!))         ///Display website
    }
    
    //MARK: Dissmiss ViewController
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
} // End ViewController
