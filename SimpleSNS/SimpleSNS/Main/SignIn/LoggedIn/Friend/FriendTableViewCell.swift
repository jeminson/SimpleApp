//
//  FriendTableViewCell.swift
//  SimpleSNS
//
//  Created by Je Min Son on 12/1/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var friendProfileImgView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var unfriendBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
