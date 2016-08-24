//
//  customTabBarController.swift
//  Diary
//
//  Created by Dharamvir on 8/23/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit

class customTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let feedController = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "Home"
        navigationController.tabBarItem.image = UIImage(named: "Home")
        
        let settingController = SettingViewController()
        let secondNavigationController = UINavigationController(rootViewController: settingController)
        secondNavigationController.title = "Settings"
        secondNavigationController.tabBarItem.image = UIImage(named: "Setting")
        
        viewControllers = [navigationController, secondNavigationController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
