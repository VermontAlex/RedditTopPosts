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
        comments.text = String(posts.num_comments)
        postImage.downloaded(from: posts.thumbnail)

        //Cuurent date for find difference between know and when post created
        //dateNow - current date. formatter - format date to format needed
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MMM d, h:mm a"
        formatter.string(from: dateNow)
        //Date when post created
        guard let timeResult = posts.created_utc else {return}
        let datePostCreated = Date(timeIntervalSince1970: timeResult)
            let createdTime = DateFormatter()
            createdTime.timeStyle = DateFormatter.Style.medium //Set time style
            createdTime.dateStyle = DateFormatter.Style.medium //Set date style
            createdTime.string(from: datePostCreated)
        //Find the difference between two dates in Hours.
        let diffComponents = Calendar.current.dateComponents([.hour], from: datePostCreated, to: dateNow)
        
        hours.text = String(diffComponents.hour ?? 0)
        }
    }

//Convert type String to URL and download image.
extension UIImageView {
    func downloaded(from url: URL) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
