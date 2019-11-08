//
//  LoadingView.swift
//  OnlineGallery
//
//  Created by Stanislav on 31.10.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import Foundation
import UIKit

final class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 5
        
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }
    
    public func animate() {
        activityIndicatorView.startAnimating()
    }
    
    public func setViewToTurnOff(){
        
    }
}
