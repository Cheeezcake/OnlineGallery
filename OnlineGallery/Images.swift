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
    var id: Int
    var name: String
    var description: String
    var new: Bool
    var popular: Bool
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
}

struct  GalleryResponse: Codable {
//    enum CodingKeys: String, CodingKey {
//        case items
//    }
    let data: [GalleryItem]
}

