//
//  Url+Extension.swift
//  On The Map
//
//  Created by Aaryan Kothari on 06/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

//MARK:- URL checker
/// Returns true if URL is a valid URL and false if not.
extension URL{
    var isValid : Bool{
        return UIApplication.shared.canOpenURL(self)
    }
}
