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
    
    var detImage: GalleryItem?
    var task: URLSessionDataTask!
    var disposeBag = DisposeBag()
    var image:UIImage? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detImageView.image = image
        self.detImageView.kf.indicatorType = .activity
        //self.detImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.detTitleLable.text = detImage!.name
        self.detDescription.text = detImage!.description
        //self.detDescription.isEditable = false
        //self.detDescription.isSelectable = false
    }
    
    
    func setTitle() {
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
