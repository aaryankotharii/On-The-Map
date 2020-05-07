//
//  Constants.swift
//  On The Map
//
//  Created by Aaryan Kothari on 06/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//


//MARK:- CONSTANTS
/// TO BE USED BY ALL / ANY VIEWCONTROLLER
import UIKit

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

var FBLogin : Bool = false

var postisExisting : Bool {
    if UserDefaults.standard.value(forKey: "objectId") == nil {
        return false
    }
    return true
}

public func debugLog(message: String) {
    #if DEBUG
    debugPrint("=======================================")
    debugPrint(message)
    debugPrint("=======================================")
    #endif
}
