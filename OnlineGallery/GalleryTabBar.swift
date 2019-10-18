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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // New VC
        guard let firstNC = self.children[0] as? UINavigationController else {
            fatalError("В расскадровке у таббара отсутствует связь с navigationController")
        }
        
        let newVC = storyboard.instantiateViewController(withIdentifier: "viewController") as? ViewController
        firstNC.pushViewController(newVC!, animated: false)
        
        //Second tab
        let tabPopular = ViewController()
        let tabPopularBarItem = UITabBarItem(title: "Tab POPULAR", image: nil, selectedImage: nil)
        
        tabPopular.tabBarItem = tabPopularBarItem
        
        //self.viewControllers = [tabNew, tabPopular]
        
        // UITabBarControllerDelegate method
        func tabBarController(_ tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
       // print(self.selectedIndex)
        }
        
    }
}

