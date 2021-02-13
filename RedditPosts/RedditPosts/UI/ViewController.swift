//
//  ViewController.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UITableViewDataSourcePrefetching {
    
    @IBOutlet weak var tableView: UITableView!
    var count = 0
    
    var posts = [ChildData]()
    var image : UIImage?
    var after: String?
    var loadMoreStatus = false
    
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    var myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        activityIndicatorView.startAnimating()
        downloadJSON(refresh: true)
        self.tableView.delegate              = self
        self.tableView.dataSource            = self
        self.tableView.prefetchDataSource    = self
        tableView.refreshControl = myRefreshControl
        view.backgroundColor = .black
        tableView.backgroundColor = .black
    }
    
    //Pull refresh Data
    @objc private func refreshData() {
        downloadJSON(refresh: true)
    }
    
    func addActivityIndicator(){
        activityIndicatorView.backgroundColor = UIColor(named: "background_color")
        activityIndicatorView.color = .white
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
        //Send url from Post url image to second VC.
        //If we have Image in Post Image open second VC if not, well then no)
        if cell.postHint == "image" {
        cell.button.didTouchUpInside = { (sender) in
            let storyboard = UIStoryboard(name: "Details", bundle: nil)
            let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsVC.urlImage = self.posts[indexPath.row].url
                    self.present(detailsVC, animated: true, completion: nil)
        }
        }
        //Sizing cell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row == posts.count - 3 && !loadMoreStatus{
            downloadJSON(query: after)
                self.count += 1
                print("FETCHED", count)
            break
        }
    }
 }
}
    
    func formUrl(afterItemName: String?) -> URL {
        let scheme = "https"
        let host = "reddit.com"
        var components = URLComponents()
        components.host = host
        components.scheme = scheme
        components.path = "/top.json"
        var queryItems = [URLQueryItem]()
        if let itemName = afterItemName{
            queryItems.append(URLQueryItem(name: "after", value: itemName))
        }
        components.queryItems = queryItems
        
        return components.url!
    }


extension ViewController {
    
    func downloadJSON(refresh: Bool = false, query: String? = nil) {
        loadMoreStatus = true
        if refresh {
            myRefreshControl.beginRefreshing()
        }
        let task = URLSession.shared.dataTask(with: formUrl(afterItemName: query)) { (data, response, error) in
            DispatchQueue.main.async {
            if refresh {
                self.myRefreshControl.endRefreshing()
            }
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return
            }
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(Post.self, from: dataResponse)
                self.after = model.data.after
                //Changing objects type to type needed from Post to ChildData
                let arrayChildrens = model.data.children
                for object in arrayChildrens {
                    self.posts.append(object.data)
                }
                DispatchQueue.main.async {
                    self.loadMoreStatus = false
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        }
        task.resume()
    }
}
