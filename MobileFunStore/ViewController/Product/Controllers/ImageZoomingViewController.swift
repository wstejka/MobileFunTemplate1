//
//  ImageZoomingViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 06/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ImageZoomingViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    var currentIndex : Int!
    var images : [UIImage]!
    private var imageViews : [UIImageView] = []
    let cellTagShift = 100
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageControl()
        setupScrollView()
    }
    
    // MARK: - Actions

    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func setupPageControl() {
        
        // The total number of pages that are available is based on how many available images we have.
        self.pageControl.numberOfPages = images.count
        self.pageControl.currentPage = max(currentIndex, 0)
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
    }

    func setupScrollView() {
        
        mainScrollView.isPagingEnabled = true
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        for arg in images.enumerated() {
            // create scroll per image to handle zomming correctly
            let scrollView = UIScrollView(frame: view.frame)
            
            scrollView.minimumZoomScale = Utils.ImageScales.min.rawValue
            scrollView.maximumZoomScale = Utils.ImageScales.max.rawValue
            scrollView.zoomScale = Utils.ImageScales.min.rawValue
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            scrollView.contentSize = CGSize(width: view.frame.width, height: scrollView.frame.height)
            scrollView.frame.origin = CGPoint(x: CGFloat(arg.offset) * view.frame.width , y: 0.0)
            scrollView.tag = arg.offset + cellTagShift
            mainScrollView.addSubview(scrollView)

            let imageView = UIImageView(frame: view.frame)
            imageView.image = arg.element
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }
        
        mainScrollView.contentSize = CGSize(width: CGFloat(images.count) * view.frame.width, height: mainScrollView.frame.height)
        mainScrollView.contentOffset = CGPoint(x: CGFloat(currentIndex) * view.frame.width, y: 0.0)
    }

    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Product", bundle: nil)) -> ImageZoomingViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "ImageZoomingViewController") as! ImageZoomingViewController
        return controller
    }

}

extension ImageZoomingViewController : UIScrollViewDelegate {
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        log.verbose("")
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.width)
        self.pageControl.currentPage = Int(pageNumber)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        let index = scrollView.tag - cellTagShift
        return imageViews[index]
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        log.verbose("\(scale)")
//        if scale == Utils.ImageScales.min.rawValue {
//            dismiss(animated: true, completion: nil)
//        }
    }
    
}



