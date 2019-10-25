//
//  GalleryTabBar.swift
//  OnlineGallery
//
//  Created by Stanislav on 18.10.2019.
//  Copyright © 2019 cheeezcake. All rights reserved.
//

import UIKit

class GalleryTabBar: UITabBarController, UITabBarControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        //       self.tabBarController?.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // First NavigationController
        guard let firstNC = self.children[0] as? UINavigationController else {
            fatalError("В раскадровке у таббара отсутствует связь с navigationController")
        }
        // First ViewController "New"
        let newVC = storyboard.instantiateViewController(withIdentifier: "viewController") as? ViewController
        newVC?.type = .new
        firstNC.pushViewController(newVC!, animated: false)
        // newVC?.tabBarItem.title = "New"
        
        
        // Second NavigationController
        guard let secondNC = self.children[1] as? UINavigationController else {
            fatalError("В раскадровке у таббара отсутствует связь с navigationController")
        }
        // Second ViewController "Popular"
        let popularVC = storyboard.instantiateViewController(withIdentifier: "viewController") as? ViewController
        popularVC?.type = .popular
        // popularVC?.tabBarItem.title = "Popular"
        secondNC.pushViewController(popularVC!, animated: false)
        
    }
}

