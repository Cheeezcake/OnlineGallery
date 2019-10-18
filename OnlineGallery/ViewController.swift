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
    var currentPage = 0
    var pageCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.dataSource = self
//        collectionView.delegate = self
            collectionView.dataSource =  self
            collectionView.delegate = self
        // let blankImages = Image(id: 1, contentUrl: "111")
        
        //  var blankGalleryItem = GalleryItem(id: 1, name: "name 1", description: "description 1", new: true, popular: true, image: blankImages)
        
        //  self.galleryItemArray = [blankGalleryItem, blankGalleryItem]
        //  func loadPictures(page: Int){
        
        //1 шаг
//        Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=false&popular=true&page=1&limit=20").responseData{ response in
//            //let json = JSON(response.result.value!)
//            let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value!)
//            self.galleryItemArray.append(contentsOf: fgalleryItemArray.data.map{ $0 })
//            //{ $0 }
//            self.collectionView.reloadData()
//            print("heey")
//  }
            loadData()
            //print(self.galleryItemArray)
            //print("Page: \(page)")
        
    }
    func loadData(){
        //Проверяем соединение с сетью
        if Connectivity.isConnectedToInternet {
            print("Connected")
            if currentPage <= pageCount {
                currentPage += 1
                print("Loading started. Page: \(currentPage) of ")
                Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=true&popular=false&page=\(currentPage)&limit=10").responseData{ response in
                    let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value! )
                    self.galleryItemArray.append(contentsOf: fgalleryItemArray.data.map{ $0 })
                    self.collectionView.reloadData()
                    self.pageCount = fgalleryItemArray.countOfPages
                    print(self.pageCount)
                }
            }
        }else {
            print("No Internet")
        }
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openDetailVC(at: indexPath.row)
    }
    
    func openDetailVC(at index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController
        vc?.detImage = galleryItemArray[index]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
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
}

extension ViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == galleryItemArray.count-1{
            loadData()
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

