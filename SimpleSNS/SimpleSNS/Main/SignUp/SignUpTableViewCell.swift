//
//  SignUpTableViewCell.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/29/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import TextFieldEffects

class SignUpTableViewCell: UITableViewCell {

    @IBOutlet weak var userInfoTextField: YoshikoTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
