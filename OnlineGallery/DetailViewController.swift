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
import RxSwift
import RxAlamofire
import Kingfisher

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var detImageView: UIImageView!
    
    @IBOutlet weak var detTitleLable: UILabel!
    
    @IBOutlet weak var detDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
        }
    }
    
    var detImage: GalleryItem?
    var task: URLSessionDataTask!
    var disposeBag = DisposeBag()
    var image:UIImage? = nil
    var originalImageSize = CGSize()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalImageSize = detImageView.frame.size
        self.detImageView.hero.id = String(self.detImage!.image.id)
        self.detImageView.image = image
        self.detImageView.kf.indicatorType = .activity
        self.detTitleLable.text = detImage!.name
        self.detDescription.text = detImage!.description
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.zoomScale = 1
    }
    
    func setTitle() {
        self.navigationController?.navigationBar.topItem?.title = " "
    }
}
