//
//  CommentTableViewCell.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate {
    
}

class CommentTableViewCell: UITableViewCell {
    
     var delegate: CommentTableViewCellDelegate?
    
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
