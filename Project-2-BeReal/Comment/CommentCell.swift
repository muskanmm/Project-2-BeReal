//
//  CommentCell.swift
//  Project-2-BeReal
//
//  Created by Muskan Mankikar on 3/15/24.
//

import UIKit

class CommentCell: UITableViewCell {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    func configure(with comment: Comment) {
        if let user = comment.user {
            usernameLabel.text = user.username
        }
        
        commentLabel.text = comment.comment
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
