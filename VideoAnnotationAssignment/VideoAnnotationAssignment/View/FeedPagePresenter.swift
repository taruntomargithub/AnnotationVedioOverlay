//
//  FeedPagePresenter.swift
//  VideoAnnotationAssignment
//
//  Created by Tarun Tomar on 13/06/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import Foundation
import AVFoundation

protocol FeedPagePresenterProtocol: class {
    func viewDidLoad()
    func fetchNextFeed() -> IndexedFeed?
    func fetchPreviousFeed() -> IndexedFeed?
    func updateFeedIndex(fromIndex index: Int)
}

class FeedPagePresenter: FeedPagePresenterProtocol {
    fileprivate unowned var view: FeedPageView
    fileprivate var feeds: [Feed] = []
    fileprivate var currentFeedIndex = 0
    
    init(view: FeedPageView) {
        self.view = view
    }
    
    func viewDidLoad() {
        configureAudioSession()
        fetchVideos()
    }
    
    func fetchNextFeed() -> IndexedFeed? {
        return getFeed(atIndex: currentFeedIndex + 1)
    }
    
    func fetchPreviousFeed() -> IndexedFeed? {
        return getFeed(atIndex: currentFeedIndex - 1)
    }
    
    func updateFeedIndex(fromIndex index: Int) {
        currentFeedIndex = index
    }
    
    
    fileprivate func configureAudioSession() {
        try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
    }
    
    fileprivate func getFeed(atIndex index: Int) -> IndexedFeed? {
        guard index >= 0 && index < feeds.count else {
            return nil
        }
        return (feed: feeds[index], index: index)
    }
}

extension FeedPagePresenter {
    fileprivate func fetchVideos() {
        var dataArray = [Feed]()
        let videoUrlArray = ["https://s3-ap-southeast-1.amazonaws.com/live-videos/feed_5dda7dfea1ccee4171c82f99_1585733021586.mp4",
             "https://s3-ap-southeast-1.amazonaws.com/live-videos/feed_5dda7dfea1ccee4171c82f99_1587039861423.mp4",
             "https://s3-ap-southeast-1.amazonaws.com/live-videos/feed_5dda7dfea1ccee4171c82f99_1585732305744.mp4",
             "https://s3-ap-southeast-1.amazonaws.com/live-videos/feed_5dda7dfea1ccee4171c82f99_1585731119417.mp4",
             "https://s3-ap-southeast-1.amazonaws.com/live-videos/feed_5dda7dfea1ccee4171c82f99_1585730926809.mp4",
             "https://s3-ap-southeast-1.amazonaws.com/live-videos/feed_5dda7dfea1ccee4171c82f99_1585716851134.mp4"]
        for (index, item) in videoUrlArray.enumerated() {
            guard let url = URL(string: item) else {continue}
            let videoItem = Feed(id: index, url: url)
            dataArray.append(videoItem)
        }
        self.feeds = dataArray
        guard let initialFeed = self.feeds.first else {
            return
        }
        view.presentInitialFeed(initialFeed)
    }
}



