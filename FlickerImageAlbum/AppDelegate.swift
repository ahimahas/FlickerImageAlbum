//
//  AppDelegate.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 16..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    struct Constant {
        static let storyboardName: String = "Main"
        static let rootViewControllerIdentifier: String = "AlbumImageViewController"
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //! initiate main window
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //! dependency injecting
        let storyboard = UIStoryboard(name: Constant.storyboardName, bundle: nil)
        guard let viewController: AlbumImageViewController = storyboard.instantiateViewController(withIdentifier: Constant.rootViewControllerIdentifier) as? AlbumImageViewController else {
            return true
        }
        
        
        let albumImageViewModel: AlbumImageViewModel = AlbumImageViewModel(networkAgent: FlickerImageDataProvider(), imageFetcher: ImagePreFetcher())
        albumImageViewModel.delegate = viewController
        viewController.viewModel = albumImageViewModel

        if let window = self.window {
            window.rootViewController = viewController
        }
        
        return true
    }
}

