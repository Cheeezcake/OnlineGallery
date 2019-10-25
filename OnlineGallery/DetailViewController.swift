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
        super.viewWillAppear(false)
        setTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
        self.detTitleLable.text = detImage!.name
        self.detDescription.text = detImage!.description
        self.detDescription.isEditable = false
        self.detDescription.isSelectable = false
    }
    
    
    func setTitle() {
       // self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = " "    }
}
