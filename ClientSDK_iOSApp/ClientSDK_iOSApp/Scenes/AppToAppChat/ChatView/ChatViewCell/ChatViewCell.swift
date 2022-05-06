//
//  ChatViewCell.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 04.05.22.
//

import UIKit

class ChatViewCell: UITableViewCell {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var dateLeft: NSLayoutConstraint!
    @IBOutlet var dateRight: NSLayoutConstraint!
    @IBOutlet var containerRight: NSLayoutConstraint!
    @IBOutlet var containerLeft: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.superview?.layer.borderWidth = 0.5
        dateLabel.superview?.layer.cornerRadius = 5
        dateLabel.superview?.layer.borderColor = UIColor.cyan.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setAlignment(_ isSender: Bool) {
        dateLeft.isActive = !isSender
        dateRight.isActive = isSender
        containerLeft.isActive = isSender
        containerRight.isActive = !isSender
        messageLabel.textAlignment = isSender ? .right : .left
        senderLabel.textAlignment = isSender ? .right : .left
        containerView.backgroundColor = isSender ? .lightGray : .blue.withAlphaComponent(0.5)
    }
}
