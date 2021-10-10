//
//  SecondModuleBuilder.swift
//  MVP-Swift-Example
//
//  Created by Dmitry Onishchuk on 09.09.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import UIKit

struct DetailModuleBuilder {
    
    func create(place: String) -> DetailVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: String(describing: DetailVC.self)) as! DetailVC
        let presenter = DetailPresenter(view: detailVC, place: place)
        detailVC.presenter = presenter
        return detailVC
    }
    
}
