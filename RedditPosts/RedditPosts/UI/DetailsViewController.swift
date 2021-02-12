//
//  DetailsViewController.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 11.02.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageFull: UIImageView?
    var urlImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = urlImage else { return }
        imageFull?.downloaded(from: url)
    }
    
    
    
    
    
}
