//
//  ViewController.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var posts = [ChildData]()
    var imagesArray = [String]()
    var after: String?
    var loadMoreStatus = false
    
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    var myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        activityIndicatorView.startAnimating()
        downloadJSON(refresh: true)
        self.tableView.delegate              = self
        self.tableView.dataSource            = self
        tableView.refreshControl = myRefreshControl
        
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
        
        imagesArray.append(posts[indexPath.row].url)
        
        cell.avatarImage.layer.cornerRadius = 20
        
        //Send url from Post url image to second VC.
        cell.button.didTouchUpInside = { (sender) in
            let storyboard = UIStoryboard(name: "Details", bundle: nil)
            let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsVC.urlImage = self.posts[indexPath.row].url
                    self.present(detailsVC, animated: true, completion: nil)
            }

        return cell
    }
}
    
    
    
    //MARK:Infinite scroll
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
//            if !loadMoreStatus {
//            downloadJSON(query: after)
//                /* "t3_lh8axc"
//                 "t3_lhji5d"    some
//                 "t3_lhli0w"    some
//
//
//                 */
//            }
//        }
//    }

   
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
                self.loadMoreStatus = false
                self.after = model.data.after
                //Changing objects type to type needed from Post to ChildData
                let arrayChildrens = model.data.children
                for object in arrayChildrens {
                    self.posts.append(object.data)
                }
                DispatchQueue.main.async {
//                    self.loadMoreStatus = false
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
