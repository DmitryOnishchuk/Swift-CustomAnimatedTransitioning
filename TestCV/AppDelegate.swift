//
//  AppDelegate.swift
//  TestCV
//
//  Created by Dmitry Onishchuk on 28.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        loadView()
        
        return true
    }

}

extension AppDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func loadView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainModuleBuilder().create()
        window?.makeKeyAndVisible()
    }
}

func print(_ items: Any...) {
    #if DEBUG
    Swift.print(items[0])
    #endif
}
