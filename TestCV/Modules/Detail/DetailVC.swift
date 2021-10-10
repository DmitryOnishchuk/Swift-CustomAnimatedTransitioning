//
//  DetailVC.swift
//  TestCV
//
//  Created by Dmitry Onishchuk on 28.09.2021.
//

import Foundation
import UIKit

protocol DetailViewProtocol: AnyObject {
    func setInfoLabel(text: String)
}

class DetailVC: UIViewController {
    
    var presenter: DetailPresenterProtocol!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("DetailVC viewDidLoad")
    }

}

extension DetailVC {
    static func instantiateViewController() -> DetailVC {
        return Storyboard.main.viewController(DetailVC.self)
    }
}

extension DetailVC: MiniToLargeAnimatable {
    var animatableBackgroundView: UIView {
        return backgroundView
    }
    
    var animatableMainView: UIView {
        return contentView
    }
    
    func prepareBeingDismissed() {
       // cardsView.hideAllCellsExceptSelected(animated: true)
    }
}


extension DetailVC: DetailViewProtocol {
    
    func setInfoLabel(text: String){
      print("PLACE: " + text)
    }
}
