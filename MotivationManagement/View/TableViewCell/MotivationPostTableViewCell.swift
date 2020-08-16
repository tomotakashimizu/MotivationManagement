//
//  MotivationPostTableViewCell.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import Cosmos

protocol MotivationPostTableViewCellDelegate {
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton)
}

class MotivationPostTableViewCell: UITableViewCell {
    
    var delegate: MotivationPostTableViewCellDelegate?
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var starCosmosView: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        
        // 影つけるコード
        contentView.backgroundColor = UIColor.clear
        
        let screenRect = UIScreen.main.bounds
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 1, width: screenRect.width, height: frame.size.height - 7))
        // 白
        whiteRoundedView.layer.backgroundColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 20
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        contentView.addSubview(whiteRoundedView)
        contentView.sendSubviewToBack(whiteRoundedView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func like(button: UIButton) {
        self.delegate?.didTapLikeButton(tableViewCell: self, button: button)
    }
    
    @IBAction func openMenu(button: UIButton) {
        self.delegate?.didTapMenuButton(tableViewCell: self, button: button)
    }
    
    @IBAction func showComments(button: UIButton) {
        self.delegate?.didTapCommentsButton(tableViewCell: self, button: button)
    }
    
}
