//
//  ItemCollectionViewCell.swift
//  OnlineGallery
//
//  Created by Stanislav on 27.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var gallery: GalleryItem?
    
    
    func setup(_ item: GalleryItem!) {
        DispatchQueue.main.async {
        if let url = URL(string: "http://gallery.dev.webant.ru/media/\(item!.image.contentUrl)"),
            let data = try? Data(contentsOf: url){
            
            self.imageView.image = UIImage(data: data)
            self.labelView.text = item!.name
            }
        }
    }
}

