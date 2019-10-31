//
//  Images.swift
//  OnlineGallery
//
//  Created by Stanislav on 27.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import Foundation
import Alamofire

struct Image: Codable {
    var id: Int
    var contentUrl: String
    
}

struct GalleryItem: Codable {
    var id: Int? = 0
    var name: String? = "nil"
    var description: String? = "nil"
    var new: Bool? = false
    var popular: Bool? = false
    var image: Image
    
}

struct  GalleryResponse: Codable {
    let countOfPages: Int
    let data: [GalleryItem]
    
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}

