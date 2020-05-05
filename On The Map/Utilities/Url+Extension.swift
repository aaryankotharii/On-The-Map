//
//  Url+Extension.swift
//  On The Map
//
//  Created by Aaryan Kothari on 06/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

extension URL{
    var isValid : Bool{
        return UIApplication.shared.canOpenURL(self)
    }
}
