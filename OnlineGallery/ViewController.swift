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
    var isLoading: Bool = false
    var page = 1
    let emptyData = Data()
   // private let itemsPerRow: CGFloat = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // let blankImages = Image(id: 1, contentUrl: "111")
        
        //  var blankGalleryItem = GalleryItem(id: 1, name: "name 1", description: "description 1", new: true, popular: true, image: blankImages)
        
        //  self.galleryItemArray = [blankGalleryItem, blankGalleryItem]
      //  func loadPictures(page: Int){
            Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=false&popular=true&page=1&limit=20").responseData{ response in
                //let json = JSON(response.result.value!)
                let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value!)
                self.galleryItemArray.append(contentsOf: fgalleryItemArray.data.map{ $0 })
                    //{ $0 }
                self.collectionView.reloadData()
                print("heey")
                //print(self.galleryItemArray)
                //print("Page: \(page)")
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

extension ViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        if contentOffsetX >= (scrollView.contentSize.width - scrollView.bounds.width) - 1 /* Needed offset */ {
            guard !self.isLoading else { return }
            self.isLoading = true
            // load more data
            // than set self.isLoading to false when new data is loaded
            page += 1
//        let lastSectionIndex = (self.collectionView?.numberOfSections)! - 1
//        let lastItemIndex = (self.collectionView.numberOfItems(inSection: lastSectionIndex))
//        if (indexPath.row == (lastItemIndex - 1 )){
            Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=false&popular=true&page=\(page)&limit=20").responseData{ response in
                //let json = JSON(response.result.value!)
                let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value! )
                self.galleryItemArray.append(contentsOf: fgalleryItemArray.data.map{ $0 })
                //{ $0 }
                self.collectionView.reloadData()
                print("heey extension, page \(self.page)")
                self.isLoading = false
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width-45) / 2.0
        let yourHeight = yourWidth * 0.71
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return UIEdgeInsets.zero
        return UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

