//
//  TableViewCell.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillCell(posts: ChildData) {
        titlePost.text = posts.title
        authorName.text = posts.author
        }
    }
