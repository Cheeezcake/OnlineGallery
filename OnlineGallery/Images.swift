//
//  Images.swift
//  OnlineGallery
//
//  Created by Stanislav on 27.09.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import Foundation

struct Image: Codable {
    var id: Int
    var contentUrl: String
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case contentUrl
//    }
}

struct GalleryItem: Codable {
    var id: Int? = 0
    var name: String? = "nil"
    var description: String? = "nil"
    var new: Bool? = false
    var popular: Bool? = false
    var image: Image
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case description
//        case new
//        case popular
//        case image
//
//    }
//   init() {
    
//    }
}

struct  GalleryResponse: Codable {
//    enum CodingKeys: String, CodingKey {
//        case items
//    }
    let data: [GalleryItem]
//    init() {
        
//    }
}

