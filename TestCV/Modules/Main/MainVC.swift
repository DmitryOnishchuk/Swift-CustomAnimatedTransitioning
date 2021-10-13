//
//  ViewController.swift
//  TestCV
//
//  Created by Dmitry Onishchuk on 28.09.2021.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var placesCollectionView: UICollectionView!
    @IBOutlet weak var placesCollectionViewHeight: NSLayoutConstraint!
    private let placesCollectionViewCellIdentifier = "PlaceCollectionViewCell"
    private var places: [String] = ["Test1", "Test2", "Test3", "Test4"]
    
    @IBOutlet weak var bottomTriggerViewStatic: UIView!
    
    //let transition = MiniToLargeTransitionCoordinator()
    
    var transitions: [Int: MiniToLargeTransitionCoordinator] = [:]
    
    //var CVCellWidth:CGFloat!
    //var CVCellHeight:CGFloat = 100
    //let spaceBetweenCell:Float = 10
    
    private let cellLineSpaceValue: CGFloat = 18.0 // for space between cells
    private let cellLeadingConstant: CGFloat = 30.0 // for adding spaces to cell's width from left & right sides
    
    private var cellWidth: CGFloat = 0
    private var cellHeight: CGFloat = 0
    
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        cellHeight = placesCollectionViewHeight.constant
        
        placesCollectionView.delegate = self
        placesCollectionView.dataSource = self
        placesCollectionView.register(UINib(nibName: placesCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: placesCollectionViewCellIdentifier)
        
        
        
        cellWidth = UIScreen.main.bounds.width - cellLeadingConstant * 2.0
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: cellLeadingConstant,
                                           bottom: 0,
                                           right: cellLeadingConstant)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellLineSpaceValue
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        // layout.headerReferenceSize = CGSize(width: cellLineSpaceValue, height: 0)
        //layout.footerReferenceSize = CGSize(width: cellLineSpaceValue, height: 0)
        
        placesCollectionView.collectionViewLayout = layout
        placesCollectionView.decelerationRate = .fast
        
        let topInset = placesCollectionView.frame.height - cellHeight
        placesCollectionView.contentInset.top = topInset
        placesCollectionView.contentInset.bottom = 0
        
        placesCollectionView.performBatchUpdates(nil, completion: {(result) in
            if !self.places.isEmpty{
                self.prepareTransition(index: 0)
            }
        })
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // self.pageControl.numberOfPages = places.count
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = placesCollectionView.dequeueReusableCell(withReuseIdentifier: placesCollectionViewCellIdentifier, for: indexPath) as! PlaceCollectionViewCell
        cell.roundCorners(top: true, cornerRadii: 10.0)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = Float(cellWidth + cellLineSpaceValue)
        currentPageIndex = Int(floor((Float(scrollView.contentOffset.x) - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(cellWidth + cellLineSpaceValue)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.placesCollectionView.contentSize.width)
        var newPage = Float(currentPageIndex)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? currentPageIndex + 1 : currentPageIndex - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        currentPageIndex = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
        prepareTransition(index: currentPageIndex)
    }
    
    func prepareTransition(index: Int){
        print(index)
        let cell = placesCollectionView.cellForItem(at: IndexPath(item: Int(index), section: 0))
        let tr = MiniToLargeTransitionCoordinator()
        tr.prepareViewForCustomTransition(fromViewController: self, bottomTriggerView: cell!.contentView, textForDetailVC: places[index])
        transitions.updateValue(tr, forKey: index)
    }
    
}

extension MainVC {
    static func instantiateViewController() -> MainVC {
        return Storyboard.main.viewController(MainVC.self)
    }
}

extension MainVC: InteractiveTransitionableViewController {
    var interactivePresentTransition: MiniToLargeViewInteractiveAnimator? {
        return transitions[currentPageIndex]!.interactivePresentTransition
    }
    var interactiveDismissTransition: MiniToLargeViewInteractiveAnimator? {
        return transitions[currentPageIndex]!.interactiveDismissTransition
    }
}
