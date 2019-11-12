//
//  ViewController.swift
//  OnlineGallery
//
//  Created by Stanislav on 26.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Hero

enum SourceType {
    case new
    case popular
}

fileprivate struct Constants {
    /// an arbitrary tag id for the loading view, so it can be retrieved later without keeping a reference to it
    fileprivate static let loadingViewTag = 1234
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
    var disposeBag = DisposeBag()
    
    override func viewDidAppear(_ animated: Bool) {
        self.setTitle()
        super.viewDidAppear(false)
        self.hero.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource =  self
        collectionView.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged )
        collectionView.addSubview(refreshControl)
        loadData(){
            DispatchQueue.main.async {
                if self.currentArrayOfItems().count > 0{
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func loadData(completionHandler: (() ->Void)?){
        DispatchQueue.global().async {
            if Connectivity.isConnectedToInternet {
                print("Connected")
                self.showCells()
                if self.type == .new{
                    if self.currentPageOfNew <= self.pageCountOfNew {
                        self.currentPageOfNew += 1
                        print("Loading 'New' started. Page: \(self.currentPageOfNew)")
                        _ = data(.get, "http://gallery.dev.webant.ru/api/photos?new=true&popular=false&page=\(self.currentPageOfNew)&limit=10")
                            .observeOn(MainScheduler.instance)
                            .subscribe(onNext: { data in
                                let tempGalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: data)
                                self.galleryItemArrayNew.append(contentsOf: tempGalleryItemArray.data.map{ $0 })
                                self.collectionView.reloadData()
                                self.pageCountOfNew = tempGalleryItemArray.countOfPages
                            }, onError: { error in
                                print(error)
                            },
                               onCompleted:{
                              //  print("Completed")
                                completionHandler?()
                            })
                        print("of \(self.pageCountOfNew)")
                    }
                } else {
                    if self.currentPageOfPopular <= self.pageCountOfPopular {
                        self.currentPageOfPopular += 1
                        print("Loading 'Popular' started. Page: \(self.currentPageOfPopular)")
                        _ = data(.get, "http://gallery.dev.webant.ru/api/photos?new=false&popular=true&page=\(self.currentPageOfPopular)&limit=10")
                            .observeOn(MainScheduler.instance)
                            .subscribe(onNext: { data in
                                let tempGalleryItemArray: GalleryResponse = try! JSONDecoder().decode(GalleryResponse.self, from: data)
                                self.galleryItemArrayPopular.append(contentsOf: tempGalleryItemArray.data.map{ $0 })
                                self.collectionView.reloadData()
                                self.pageCountOfPopular = tempGalleryItemArray.countOfPages
                            }, onError: { error in
                                print(error)
                            },
                               onCompleted:{
                               // print("Completed")
                                completionHandler?()
                            })
                        print("of \(self.pageCountOfPopular)")
                    }
                }
            }else {
                self.hideCells()
                print("No Internet")
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
    
    func currentArrayOfItems() -> [GalleryItem] {
        if type == .new {
            return galleryItemArrayNew
        } else {
            return galleryItemArrayPopular
        }
    }
    
    func setTitle(){
        if type == .new {
            self.navigationItem.title = "New"
        } else {
            self.navigationItem.title = "Popular"
        }
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
        loadData() {
            DispatchQueue.main.async {
                if self.currentArrayOfItems().count > 0 {
                    self.collectionView.reloadData()
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, Loadable{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openDetailVC(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currentArrayOfItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell{
            
            if currentArrayOfItems().count > 0 {
                itemCollectionCell.setup(currentArrayOfItems()[indexPath.row])
            }
            
            itemCollectionCell.configureCellShape()
            
            return itemCollectionCell
            
        }
        return UICollectionViewCell()
    }
    
    func hideCells(){
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.noConnectionImage.isHidden = false
            self.noConnectionTitle.isHidden = false
        }
    }
    
    func showCells(){
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
        }
    }
    
    func openDetailVC(at index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController
        vc?.detImage = currentArrayOfItems()[index]
        let stringURL = "http://gallery.dev.webant.ru/media/\(currentArrayOfItems()[index].image.contentUrl)"
        var image = UIImage()
        _ = data(.get, stringURL)
            .debug()
            .observeOn(MainScheduler.instance)
            .do(onNext: { data in
                image = UIImage(data: data)!
                vc?.image = image
                print(data)
            }, onError: { (error) in
                print(error)
            }, onCompleted: {
                print("Completed")
                self.navigationController?.pushViewController(vc!, animated: true)
            }, onSubscribe: {
                print("Subscription")
                self.showLoadingView()
            }, onSubscribed: {
                print("Subscribed")
            }, onDispose: {
                self.hideLoadingView()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == currentArrayOfItems().count-4{
            loadData() {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
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
    
    func showLoadingView() {
        if let items = tabBarController?.tabBar.items {
            items.forEach { $0.isEnabled = false }
        }
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.animate()
        isTapToCancelEnabled()
        loadingView.tag = Constants.loadingViewTag
    }
    
    func hideLoadingView() {
        if let items = tabBarController?.tabBar.items {
            items.forEach { $0.isEnabled = true }
        }
        view.subviews.forEach { subview in
            if subview.tag == Constants.loadingViewTag {
                subview.removeFromSuperview()
            }
        }
    }
    
    func isTapToCancelEnabled() {
        let tapToCancelLoading = UIView()
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cancelLoadingView(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapToCancelLoading.addGestureRecognizer(tapGesture)
        tapToCancelLoading.isUserInteractionEnabled = true
        tapToCancelLoading.tag = Constants.loadingViewTag
        tapToCancelLoading.frame = UIScreen.main.bounds
        view.addSubview(tapToCancelLoading)
    }
    
    @objc func cancelLoadingView(_ sender: UITapGestureRecognizer) {
        self.hideLoadingView()
        disposeBag = DisposeBag()
    }
}
