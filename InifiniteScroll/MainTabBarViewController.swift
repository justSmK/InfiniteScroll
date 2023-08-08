//
//  MainTabBarViewController.swift
//  InifiniteScroll
//
//  Created by Sergei Semko on 8/8/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: TopViewController())
        let vc2 = UINavigationController(rootViewController: AskViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "questionmark")
        
        vc1.title = "Top Stories"
        vc2.title = "Ask Stories"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
    }


}

