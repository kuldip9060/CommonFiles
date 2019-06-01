//
//  Label.swift
//  DriverSafety
//
//  Created by SYS004 on 10/22/16.
//  Copyright © 2016 MoveoApps. All rights reserved.
//

import UIKit

class Label: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.text = self.text?.localized(lang: UserDefaults.standard.object(forKey:Constants.kLanguage) as! String)
    }

}
