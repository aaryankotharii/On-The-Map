//
//  Constants.swift
//  On The Map
//
//  Created by Aaryan Kothari on 06/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit


let storyboard = UIStoryboard(name: "Main", bundle: nil)

public func debugLog(message: String) {
    #if DEBUG
    debugPrint("=======================================")
    debugPrint(message)
    debugPrint("=======================================")
    #endif
}
