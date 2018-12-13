//
//  ChatTableViewCell.swift
//  SimpleSNS
//
//  Created by Je Min Son on 12/11/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var receiverMesssageLabel: UILabel!
    @IBOutlet weak var receiverFirstNameLabel: UILabel!
    @IBOutlet weak var receiverProfileImgView: UIImageView!
    @IBOutlet weak var receiverTimeLabel: UILabel!
    
    @IBOutlet weak var senderProfileImgView: UIImageView!
    @IBOutlet weak var senderFirstNameLabel: UILabel!
    @IBOutlet weak var senderMessageLabel: UILabel!
    @IBOutlet weak var senderTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
