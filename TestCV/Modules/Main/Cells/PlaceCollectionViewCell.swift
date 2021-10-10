//
//  PlaceCollectionViewCell.swift
//  TestCV
//
//  Created by Dmitry Onishchuk on 28.09.2021.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        containerView.backgroundColor = UIColor.red
    }
    
}
