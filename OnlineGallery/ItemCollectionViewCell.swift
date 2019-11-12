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
    
    @IBOutlet weak public var imageView: UIImageView!
        
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage()
    }
    
    func setup(_ item: GalleryItem!) {
        imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: "http://gallery.dev.webant.ru/media/\(item!.image.contentUrl)")!,
                                   options: [
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .processor(DownsamplingImageProcessor(size: imageView.frame.size)),
                                    //.cacheOriginalImage
                                    .alsoPrefetchToMemory
            ])
        imageView.hero.id = String(item!.image.id)
    }

    func configureCellShape() {
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
            layer.borderColor = newValue?.cgColor
        }
    }
}

