//
//  ViewController.swift
//  OnlineGallery
//
//  Created by Stanislav on 26.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit
import Alamofire
enum SourceType {
    case new
    case popular
}
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    public var type: SourceType!
    
    @IBOutlet weak var noConnectionImage: UIImageView!
    @IBOutlet weak var noConnectionTitle: UILabel!
    @IBOutlet weak public var newOrPopularTitle: UILabel!
    
    
    var galleryItemArrayNew = [GalleryItem]()
    var galleryItemArrayPopular = [GalleryItem]()
    var currentPageOfNew = 0
    var currentPageOfPopular = 0
    var pageCountOfNew = 0
    var pageCountOfPopular = 0

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

            collectionView.dataSource =  self
            collectionView.delegate = self

            loadData()
        
    }
  @objc func loadData(){
        //Проверяем соединение с сетью
        if Connectivity.isConnectedToInternet {
            print("Connected")
            showCells()
            if type == .new{
                self.newOrPopularTitle.text = "New"
                if currentPageOfNew <= pageCountOfNew {
                    currentPageOfNew += 1
                    print("Loading 'New' started. Page: \(currentPageOfNew) of ")
                    Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=true&popular=false&page=\(currentPageOfNew)&limit=4").responseData{ response in
                        let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value! )
                        self.galleryItemArrayNew.append(contentsOf: fgalleryItemArray.data.map{ $0 })
                        self.collectionView.reloadData()
                        self.pageCountOfNew = fgalleryItemArray.countOfPages
                        print(self.pageCountOfNew)
                    }
                }
            } else {
                self.newOrPopularTitle.text = "Popular"
                if currentPageOfPopular <= pageCountOfPopular {
                    currentPageOfPopular += 1
                    print("Loading 'Popular' started. Page: \(currentPageOfPopular) of ")
                    Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=false&popular=true&page=\(currentPageOfPopular)&limit=4").responseData{ response in
                        let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value! )
                        self.galleryItemArrayPopular.append(contentsOf: fgalleryItemArray.data.map{ $0 })
                        self.collectionView.reloadData()
                        self.pageCountOfPopular = fgalleryItemArray.countOfPages
                        print(self.pageCountOfPopular)
                    }
                }
            }
        }else {
           //here to hide cells
            hideCells()
            noConnectionImage.isHidden = false
            noConnectionTitle.isHidden = false
            print("No Internet")
            let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                         selector: #selector(loadData),
                                         userInfo: nil, repeats: false)
        }
    }
     func chooseArray() -> [GalleryItem] {
        if type == .new {
            return galleryItemArrayNew
        } else {
            return galleryItemArrayPopular
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func hideCells(){
        collectionView.isHidden = true
    }
    
    func showCells(){
        collectionView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openDetailVC(at: indexPath.row)
    }
    
    func openDetailVC(at index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController
        vc?.detImage = chooseArray()[index]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chooseArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell{
        
            itemCollectionCell.setup(chooseArray()[indexPath.row])
            
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
        if indexPath.row == chooseArray().count-1{
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
        return UIEdgeInsets(top:20, left: 15, bottom: 0, right: 15)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

