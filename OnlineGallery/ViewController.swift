//
//  ViewController.swift
//  OnlineGallery
//
//  Created by Stanislav on 26.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var galleryItemArray = [GalleryItem]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 00.0,
                                             bottom: 50.0,
                                             right: 00.0)


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
       // let blankImages = Image(id: 1, contentUrl: "111")
        
      //  var blankGalleryItem = GalleryItem(id: 1, name: "name 1", description: "description 1", new: true, popular: true, image: blankImages)
        
      //  self.galleryItemArray = [blankGalleryItem, blankGalleryItem]
        
        Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=false&popular=true&page=1&limit=20").responseData{ response in
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
            
            itemCollectionCell.layer.cornerRadius = 20.0
            itemCollectionCell.layer.borderWidth = 1.0
            itemCollectionCell.layer.borderColor = UIColor.clear.cgColor
            itemCollectionCell.layer.masksToBounds = true
            
            itemCollectionCell.layer.shadowColor = UIColor.lightGray.cgColor
            itemCollectionCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            itemCollectionCell.layer.shadowRadius = 3.0
            itemCollectionCell.layer.shadowOpacity = 0.5
            itemCollectionCell.layer.masksToBounds = false
            itemCollectionCell.layer.shadowPath = UIBezierPath(roundedRect: itemCollectionCell.bounds, cornerRadius: itemCollectionCell.layer.cornerRadius).cgPath
            itemCollectionCell.layer.backgroundColor = UIColor.clear.cgColor
            
            return itemCollectionCell
        }
        return UICollectionViewCell()
    }
    
  
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (view.frame.width - 20) / 2.0
//        return CGSize(width: width, height: width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width-30) / 2.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return UIEdgeInsets.zero
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

