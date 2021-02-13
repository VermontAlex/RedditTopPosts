//
//  Button.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 12.02.2021.
//

import UIKit

class Button: UIButton {

  typealias DidTapButton = (Button) -> ()
    
    var didTouchUpInside: DidTapButton? {
        didSet{
            if didTouchUpInside != nil{
                addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func didTouchUpInside(_ sender: UIButton) {
        if let handler = didTouchUpInside {
            handler(self)
        }
        
    }
}
