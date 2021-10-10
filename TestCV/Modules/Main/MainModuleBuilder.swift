//
//  MainModuleBuilder.swift
//  MVP-Swift-Example
//
//  Created by Dmitry Onishchuk on 09.09.2021.
//

import UIKit

struct MainModuleBuilder {
    
    func create() -> MainVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: String(describing: MainVC.self)) as! MainVC
        return mainVC
    }
    
}
