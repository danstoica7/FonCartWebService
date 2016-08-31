//
//  ObjectTVCell.swift
//  DemoFonCartWebService
//
//  Created by Dan on 8/21/16.
//  Copyright © 2016 dolphin. All rights reserved.
//

import UIKit

class ObjectTVCell: UITableViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
