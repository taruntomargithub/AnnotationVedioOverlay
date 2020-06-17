//
//  FeedViewController.swift
//  VideoAnnotationAssignment
//
//  Created by Tarun Tomar on 13/06/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class FeedViewController: AVPlayerViewController, StoryboardScene {
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    fileprivate var feed: Feed!
    fileprivate var isPlaying: Bool!
    fileprivate let loadingIndicator: UIAlertController = {
        let loadingAlertController: UIAlertController = UIAlertController(title: "Updating", message: nil, preferredStyle: .alert)
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        loadingAlertController.view.addSubview(activityIndicator)

        let xConstraint: NSLayoutConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingAlertController.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint: NSLayoutConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: loadingAlertController.view, attribute: .centerY, multiplier: 1.4, constant: 0)

        NSLayoutConstraint.activate([ xConstraint, yConstraint])
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        let height: NSLayoutConstraint = NSLayoutConstraint(item: loadingAlertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        loadingAlertController.view.addConstraint(height);
        return loadingAlertController
    }()
        
    static func instantiate(feed: Feed, andIndex index: Int, isPlaying: Bool = false) -> UIViewController {
        let viewController = FeedViewController.instantiate()
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFeed()
        self.videoGravity = .resizeAspectFill
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         player?.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        player?.play()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    fileprivate func initializeFeed() {
        print("FEED URL : \(feed.url)")
        let url = feed.url
        player = AVPlayer(url: url)
        isPlaying ? play() : nil
    }
    
    @IBAction func addText(_ sender: Any) {
        let addTextAlert = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)
        addTextAlert.addTextField()
        let textfield = addTextAlert.textFields?.first
        let addTodoAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.present(self.loadingIndicator, animated: true, completion: nil)
            // call overlay editor method
            VideoEditor.loadVideo(feed: &self.feed, anotationText: textfield?.text ?? "no text added") { [weak self] (isSaved, path)  in
                if isSaved {
                    DispatchQueue.main.async {
                        self?.loadingIndicator.dismiss(animated: true, completion: {
                        })
                        self?.player = AVPlayer(url: URL(fileURLWithPath: path!))
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        addTextAlert.addAction(addTodoAction)
        addTextAlert.addAction(cancelAction)
        present(addTextAlert, animated: true, completion: nil)
    }
}


