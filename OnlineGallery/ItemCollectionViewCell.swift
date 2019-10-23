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
        let processor = CroppingImageProcessor(size: CGSize(width: 500, height: 400), anchor: CGPoint(x: 0.5, y: 0.5))
        imageView.kf.indicatorType = .activity

        self.imageView.kf.setImage(with: URL(string: "http://gallery.dev.webant.ru/media/\(item!.image.contentUrl)")!,
                                   placeholder: UIImage(named: "placeholderImage"),
                                   options: [
                                    .processor(processor),
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .cacheOriginalImage
            ])
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

