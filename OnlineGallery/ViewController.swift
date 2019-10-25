//
//  ViewController.swift
//  OnlineGallery
//
//  Created by Stanislav on 26.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

enum SourceType {
    case new
    case popular
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    public var type: SourceType!
    
    @IBOutlet weak var noConnectionImage: UIImageView!
    @IBOutlet weak var noConnectionTitle: UILabel!
    
    private let refreshControl = UIRefreshControl()
    var galleryItemArrayNew = [GalleryItem]()
    var galleryItemArrayPopular = [GalleryItem]()
    var currentPageOfNew = 0
    var currentPageOfPopular = 0
    var pageCountOfNew = 0
    var pageCountOfPopular = 0
    
    override func viewWillAppear(_ animated: Bool) {
        self.setTitle()
        
        super.viewWillAppear(false)
        self.setTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource =  self
        collectionView.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged )
        collectionView.addSubview(refreshControl)
        loadData(){DispatchQueue.main.async {
            if self.chooseArray().count > 0{
                self.collectionView.reloadData()
            }
            }}
    }
    
    @objc func loadData(completionHandler: (() ->Void)?){
        DispatchQueue.global().async {
            if Connectivity.isConnectedToInternet {
                print("Connected")
                self.showCells()
                if self.type == .new{
                    if self.currentPageOfNew <= self.pageCountOfNew {
                        self.currentPageOfNew += 1
                        print("Loading 'New' started. Page: \(self.currentPageOfNew) of ")
                        Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=true&popular=false&page=\(self.currentPageOfNew)&limit=4").responseData{ response in
                            let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value! )
                            self.galleryItemArrayNew.append(contentsOf: fgalleryItemArray.data.map{ $0 })
                            self.collectionView.reloadData()
                            self.pageCountOfNew = fgalleryItemArray.countOfPages
                            print(self.pageCountOfNew)
                            completionHandler?()
                            
                        }
                    }
                } else {
                    if self.currentPageOfPopular <= self.pageCountOfPopular {
                        self.currentPageOfPopular += 1
                        print("Loading 'Popular' started. Page: \(self.currentPageOfPopular) of ")
                        Alamofire.request("http://gallery.dev.webant.ru/api/photos?new=false&popular=true&page=\(self.currentPageOfPopular)&limit=4").responseData{ response in
                            let fgalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: response.result.value! )
                            self.galleryItemArrayPopular.append(contentsOf: fgalleryItemArray.data.map{ $0 })
                            self.collectionView.reloadData()
                            self.pageCountOfPopular = fgalleryItemArray.countOfPages
                            print(self.pageCountOfPopular)
                            completionHandler?()
                            
                        }
                    }
                }
            }else {
                //here to hide cells
                self.hideCells()
                self.noConnectionImage.isHidden = false
                self.noConnectionTitle.isHidden = false
                print("No Internet")
                //                DispatchQueue.main.async {
                //                    let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                //                                                 selector: #selector(self.loadData),
                //                                                 userInfo: nil, repeats: false)
                //                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                    self.loadData() {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                })
                completionHandler?()
            }
        }
    }
    func chooseArray() -> [GalleryItem] {
        if type == .new {
            return galleryItemArrayNew
        } else {
            return galleryItemArrayPopular
        }
    }
    
    func setTitle(){
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        if type == .new {
                self.navigationController?.navigationBar.topItem?.title = "New"

        } else {
                self.navigationController?.navigationBar.topItem?.title = "Popular"
        }
        //self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func refreshData(){
        if type == .new{
            currentPageOfNew = 0
            pageCountOfNew = 0
            galleryItemArrayNew = [GalleryItem]()
        } else {
            currentPageOfPopular = 0
            pageCountOfPopular = 0
            galleryItemArrayPopular = [GalleryItem]()
        }
        
        loadData(){DispatchQueue.main.async {
            if self.chooseArray().count > 0 {
                self.collectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
            
            }}
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
            
            if chooseArray().count > 0 {
                itemCollectionCell.setup(chooseArray()[indexPath.row])
            }
            
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
            loadData(){DispatchQueue.main.async {
                self.collectionView.reloadData()
                }}
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width-45) / 2.0
        let yourHeight = yourWidth * 0.71
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 15, bottom: 0, right: 15)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

