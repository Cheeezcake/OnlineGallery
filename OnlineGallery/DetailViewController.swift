//
//  DetailScreen.swift
//  OnlineGallery
//
//  Created by Stanislav on 16.10.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detImageView: UIImageView!
    
    
    var detImage: GalleryItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            //let processor = CroppingImageProcessor(size: CGSize(width: 800, height: 500), anchor: CGPoint(x: 0.5, y: 0.5))
            //imageView.kf.indicatorType = .activity
            detImageView.kf.indicatorType = .activity
            
        self.detImageView.kf.setImage(with: URL(string: "http://gallery.dev.webant.ru/media/\(detImage!.image.contentUrl)")!,
                                       placeholder: UIImage(named: "placeholderImage"),
                                       options: [
                                        //.processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                ])
        self.detImageView.contentMode = UIView.ContentMode.scaleAspectFit
        print(detImage?.image.contentUrl)
    }
}
