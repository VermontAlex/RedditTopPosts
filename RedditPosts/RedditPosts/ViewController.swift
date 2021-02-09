//
//  ViewController.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var posts = [ChildData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSON()
        self.tableView.delegate              = self
        self.tableView.dataSource            = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        //Filling cell
        cell.fillCell(posts: posts[indexPath.row])
        cell.avatarImage.layer.cornerRadius = 20
//        cell.postImage.contentMode = .scaleToFill
        
        
        
        return cell
    }
    
}

extension ViewController {
    func downloadJSON(){
        guard let url = URL(string: "https://www.reddit.com/top.json") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return
            }

            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(Post.self, from: dataResponse)
                //Changing objects type to type needed from Post to ChildData
                let arrayChildrens = model.data.children
                for object in arrayChildrens {
                    let child = object.data
                    self.posts.append(child)
                    print("!!START_OF_OBJECT!!",child,"!!END_OF_OBJECT!!")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}
