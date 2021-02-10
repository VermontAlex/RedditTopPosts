//
//  ViewController.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    var posts = [ChildData]()
//    var fetchingMore = false
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
//    var myRefreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        return refreshControl
//    }()
    
//    var loadMoreStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        activityIndicatorView.startAnimating()
        downloadJSON()
        self.tableView.delegate              = self
        self.tableView.dataSource            = self
//        tableView.refreshControl = myRefreshControl
    }
    
//    @objc private func refreshData() {
//        print("!!!!!!!!!!!START REFRESH!!!!!!!!")
//        downloadJSON()
//        print("!!!!!!!!!!!!!!!!!!!!!END REFRESH !!!!!!!!!!!!!")
//    }
    
    func addActivityIndicator(){
        activityIndicatorView.backgroundColor = UIColor(named: "background_color")
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        //Filling cell
        cell.fillCell(posts: posts[indexPath.row])
        cell.avatarImage.layer.cornerRadius = 20

        return cell
    }
    
    //MARK:Infinite scroll
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        let deltaOffset = maximumOffset - currentOffset
//
//        if deltaOffset <= 0 {
//            downloadJSON()
//        }
//    }
    
    
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
                    print("!!!!!!CHILD!!!!!",child,"!!!!!!!!!")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
             } catch let parsingError {
                print("Error", parsingError)
           }
        
        }
        task.resume()
    }
}
