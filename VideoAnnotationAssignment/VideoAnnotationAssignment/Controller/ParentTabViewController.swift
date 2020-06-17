//
//  ParentTabViewController.swift
//  VideoAnnotationAssignment
//
//  Created by Tarun Tomar on 13/06/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import UIKit

class ParentTabViewController: UITabBarController {

    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.frame = CGRect(x: 100, y: 0, width: 44, height: 44)
        button.backgroundColor = .white
        button.layer.borderWidth = 4
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
        button.layer.cornerRadius = 32
    }
    
    @objc fileprivate func action(sender: UIButton) {
        for item in self.children {
            if let feedPageController = item as? FeedPageViewController {
                if feedPageController.currentFeedController != nil {
                    feedPageController.currentFeedController?.addText(sender)
                }
            }
        }
    }
}



