//
//  Constants.swift
//  On The Map
//
//  Created by Aaryan Kothari on 06/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit


let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

var FBLogin : Bool = false

public func debugLog(message: String) {
    #if DEBUG
    debugPrint("=======================================")
    debugPrint(message)
    debugPrint("=======================================")
    #endif
}
