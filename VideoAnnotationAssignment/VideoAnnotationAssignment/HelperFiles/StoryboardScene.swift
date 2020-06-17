//
//  StoryboardScene.swift
//  VideoAnnotationAssignment
//
//  Created by Tarun Tomar on 13/06/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardScene: class {
    static var sceneStoryboard: UIStoryboard { get }
    static var sceneIdentifier: String { get }
}

extension StoryboardScene {
    static var sceneIdentifier: String {
        return String(describing: self)
    }
}

extension StoryboardScene where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = Self.sceneStoryboard
        let viewController = storyboard.instantiateViewController(withIdentifier: self.sceneIdentifier)
        guard let conformingViewController = viewController as? Self else {
            fatalError("View Controller Is Not Of Type or Class '\(self)'.")
        }
        return conformingViewController
    }
}
