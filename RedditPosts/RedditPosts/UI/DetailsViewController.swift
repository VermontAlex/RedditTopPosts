//
//  DetailsViewController.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 11.02.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageFull: UIImageView? //TODO: strange var name
    var urlImage : String?
    var savingArray: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = urlImage else { return }
        imageFull?.download(from: url)
        view.backgroundColor = .black
        imageFull?.backgroundColor = .black
    }
    
    @IBAction func saveShareButton(_ sender: UIButton) {
        if let image = imageFull?.image {
            let alert = UIAlertController(title: "Saved", message: "Saved are done", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            alert.dismiss(animated: true, completion: nil)
            UIImageWriteToSavedPhotosAlbum((image), nil, nil, nil)
        } else {
            let alert = UIAlertController(title: "No image to save", message: "", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
