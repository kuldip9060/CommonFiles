//
//  SimpleTblCell.swift
//  oomph
//
//  Created by Appuno Solutions on 06/06/19.
//  Copyright © 2019 Ecosmob. All rights reserved.
//

import UIKit

class SimpleTblCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfigure<T:cscCommon>(data : T){
        textLabel?.text = data.name
        
        /*if let aData = data as? Country {
            textLabel?.text = aData.name
        }
        else if let aData = data as? State{
            textLabel?.text = aData.name
        }
        else if let aData = data as? City{
            textLabel?.text = aData.name
        }*/
    }

}
