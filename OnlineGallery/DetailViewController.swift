//
//  DetailScreen.swift
//  OnlineGallery
//
//  Created by Stanislav on 16.10.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
import Kingfisher
import RxSwift
import RxAlamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detImageView: UIImageView!
    
    @IBOutlet weak var detTitleLable: UILabel!
    
    @IBOutlet weak var detDescription: UITextView!
    ///
    ///
    var detImage: GalleryItem?
    var task: URLSessionDataTask!
    var disposeBag = DisposeBag()
    var image:UIImage? = nil
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //task.progress
        setTitle()
    }
    
   // var test: Resource = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
            

        //var hitPoints = Variable<UIImage>(nil)
        self.detImageView.image = image
       // let data = ImageResource(downloadURL: URL(string: "http://gallery.dev.webant.ru/media/\(detImage!.image.contentUrl)")!)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        detImageView.kf.indicatorType = .activity

//        self.detImageView.kf.setImage(with: URL(string: "http://gallery.dev.webant.ru/media/\(detImage!.image.contentUrl)")!,
//                                      placeholder: UIImage(named: "placeholderImage"),
//                                      options: [
//                                        //.processor(processor),
//                                        .scaleFactor(UIScreen.main.scale),
//                                        .transition(.fade(1)),
//                                        .cacheOriginalImage
//            ])
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
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
