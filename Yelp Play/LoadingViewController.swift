//
//  LoadingViewController.swift
//  Yelp Play
//
//  Created by Caroline LaDouce on 9/7/21.
//

import UIKit

class LoadingViewController: UIViewController {

    var loadingActivityIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        
        loadingIndicator.style = .large
        loadingIndicator.color = UIColor.white
        
        // When view appears, indicator will be animating
        loadingIndicator.startAnimating()
        
        loadingIndicator.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleBottomMargin
        ]
        
        return loadingIndicator
    }()
        
    // Give the background a "blurred effect"
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.alpha = 0.1

        blurEffectView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]

        return blurEffectView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        
        view.addSubview(loadingActivityIndicator)
        
    } // End func viewDidLoad

} // End class



