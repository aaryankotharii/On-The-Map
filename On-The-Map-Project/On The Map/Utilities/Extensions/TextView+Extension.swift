//
//  TextView+Extension.swift
//  On The Map
//
//  Created by Aaryan Kothari on 07/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

// MARK: - UITextView extension
extension UITextView {
    //MARK:- Centres Text
    func centerVerticalText() {
        self.textAlignment = .center
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}
