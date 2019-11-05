//
//  ItemCollectionViewCell.swift
//  OnlineGallery
//
//  Created by Stanislav on 27.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit
import Kingfisher

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var gallery: GalleryItem?
    
    func setup(_ item: GalleryItem!) {
        imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: "http://gallery.dev.webant.ru/media/\(item!.image.contentUrl)")!,
                                   placeholder: UIImage(named: "placeholderImage"),
                                   options: [
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .cacheOriginalImage
            ])
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
}


extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

