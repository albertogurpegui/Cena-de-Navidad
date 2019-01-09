//
//  ParticipantTableViewCell.swift
//  CenaNavidad
//
//  Created by David gimenez on 6/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameParticipant:UILabel!
    @IBOutlet weak var checkimagenPaid:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
