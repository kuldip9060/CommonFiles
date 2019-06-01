//
//  TextField.swift
//  DriverSafety
//
//  Created by SYS004 on 10/22/16.
//  Copyright © 2016 MoveoApps. All rights reserved.
//

import UIKit

@IBDesignable
class TextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeholder = self.placeholder?.localized(lang: UserDefaults.standard.object(forKey:Constants.kLanguage) as! String)
    }
    
    @IBInspectable var cornerRadius : CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width - 40, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width - 40, height: bounds.height)
    }
}
