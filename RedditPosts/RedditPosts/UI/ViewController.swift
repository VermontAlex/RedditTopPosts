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
        downloadJSON()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.refreshControl = myRefreshControl
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    //Pull refresh Data
    @objc private func refreshData() {
        downloadJSON(refresh: true)
    }
    
    func addActivityIndicator(){
        activityIndicatorView.backgroundColor = UIColor(named: "background_color")
        activityIndicatorView.color = .white
        tableView.backgroundView = activityIndicatorView
    }
    
    //TODO: in interview you will be asked if possible any other ways to set height for cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if posts[indexPath.row].post_hint == "image" {
            return 100+60+view.frame.size.width
        } else {
            return 100+60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        //Filling cell
        cell.fillCell(posts: posts[indexPath.row])
        //Send url from Post url image to second VC.
        //If we have Image in Post Image open second VC if not, well then no)
        if posts[indexPath.row].post_hint == "image" {
            cell.didTapImage = { [weak self] in //TODO: this function too heavy to be here. lets move to `func openDetail(post: ChildData)`
                let storyboard = UIStoryboard(name: "Details", bundle: nil)
                let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                detailsVC.urlImage = self?.posts[indexPath.row].url
                self?.present(detailsVC, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row == posts.count - 1 && !loadMoreStatus{
            downloadJSON(query: after)
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
                    if refresh {
                    self.posts.removeAll()
                    }
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
