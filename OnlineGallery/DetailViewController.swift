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
    
    @IBOutlet weak var detTitleLable: UILabel!
    
    @IBOutlet weak var detDescription: UITextView!
    
    
    var detImage: GalleryItem?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
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
        
        
        //        let pinchGRC = UITapGestureRecognizer(target: self, action: #selector(pinch))
        //
        //        self.detImageView.tag = 99
        //        self.detImageView.addGestureRecognizer(pinchGRC)
        //        self.detImageView.isUserInteractionEnabled = true
        self.detTitleLable.text = detImage!.name
        self.detDescription.text = detImage!.description
        self.detDescription.isEditable = false
        self.detDescription.isSelectable = false
        //print(detImage?.image.contentUrl)
    }
//    @objc func pinch(pinchRC: UITapGestureRecognizer){
//        self.view.viewWithTag(99)?.frame = CGRect(x: 0, y: 0, width: self.view.viewWithTag(99)!.frame.width + 200, height: self.view.viewWithTag(99)!.frame.height + 200)
//    }
}
