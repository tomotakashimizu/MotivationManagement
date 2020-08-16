//
//  NoRecordTableViewCell.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

class NoRecordTableViewCell: UITableViewCell {
    
    @IBOutlet var noRecordLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
