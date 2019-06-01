//
//  TextView.swift
//  DriverSafety
//
//  Created by SYS004 on 10/24/16.
//  Copyright © 2016 MoveoApps. All rights reserved.
//

import UIKit

@IBDesignable
class TextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var cornerRadius : CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
}
