//
//  ViewController.swift
//  OnlineGallery
//
//  Created by Stanislav on 26.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var galleryItemArray = [GalleryItem]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let blankImages = Image(id: 1, contentUrl: "111")
        
        var blankGalleryItem = GalleryItem(id: 1, name: "name 1", description: "description 1", new: true, popular: true, image: blankImages)
        
      //  self.galleryItemArray = [blankGalleryItem, blankGalleryItem]
        
        Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=true&popular=true&page=1&limit=15").responseData{ response in
            //let json = JSON(response.result.value!)
            let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value!)
            self.galleryItemArray = fgalleryItemArray.data.map { $0 }
            self.collectionView.reloadData()
            print("heey")
            print(self.galleryItemArray)

        }
        
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell{
        
            itemCollectionCell.setup(galleryItemArray[indexPath.row])
            
            return itemCollectionCell
        }
        return UICollectionViewCell()
    }
}

