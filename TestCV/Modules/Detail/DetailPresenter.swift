//
//  SecondPresenter.swift
//  MVP-Swift-Example
//
//  Created by Dmitry Onishchuk on 09.09.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import Foundation
import UIKit

protocol DetailPresenterProtocol {
    func setInfo(text: String)
}

final class DetailPresenter: DetailPresenterProtocol {
    
    unowned let view: DetailViewProtocol

    init(view: DetailViewProtocol, place: String) {
        self.view = view
        setInfo(text: place)
    }
    
    deinit {
        print("deinit SecondPresenter")
    }
    
    func setInfo(text: String) {
        view.setInfoLabel(text: text)
    }
    
}
