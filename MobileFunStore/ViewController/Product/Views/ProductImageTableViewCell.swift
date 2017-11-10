//
//  ProductImageTableViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 04/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

protocol ProductImageTapped {
    
    func product(images : [UIImage], tappedIn atIndex : Int)
    
}

class ProductImageTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: Vars/Consts
    private var urls : [URL?] = []
    private var imagesInScrollView : [UIImageView] = []
    var delegate : ProductImageTapped!
    var imageSectionItem : ImagesSectionItem!
    let cellTagShift = 100

    
    var item : ProductSectionItem? {
        didSet {
            guard let item = item as? ImagesSectionItem else { return }
            self.imageSectionItem = item
            urls = item.product.urls.map({ (urlName) -> URL? in
                return URL(string: urlName)
            })
            
            imagesInScrollView = []
            // Build content of embeded pageView
            let size = self.frame.size
            let pagesNumber = urls.count
            self.pageControl.numberOfPages = pagesNumber

            for index in 0..<pagesNumber {
                
                let factorRatio = size.height / size.width
                let subView = UIImageView(frame: CGRect(origin: CGPoint(x: size.width * CGFloat(index), y: 0.0),
                                                        size: CGSize(width: size.width, height: size.width * factorRatio)))
                subView.contentMode = .scaleAspectFit
                subView.sd_setImage(with: urls[index], completed: nil)
                subView.tag = index + cellTagShift
//                subView.backgroundColor = (subView.tag % 2) == 0 ? .blue : .orange
                imagesInScrollView.append(subView)
                
                scrollView.addSubview(subView)
                
            }
            scrollView.contentSize = CGSize(width: size.width * CGFloat(urls.count),
                                            height: size.height * imageSectionItem.heightFactor)
            scrollView.isPagingEnabled = true
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        log.verbose("")
        scrollView.delegate = self
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(processGesture)))
        scrollView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(processGesture)))
        scrollView.isUserInteractionEnabled = true

        // Do any additional setup after loading the view, typically from a nib.
        configurePageControl()

    }
    
    @objc func processGesture(gesture : UIGestureRecognizer) {
        
        log.verbose("")
        // Find the tapped UIImageView
        let index : Int = Int(scrollView.contentOffset.x / self.frame.size.width)
        let images = imagesInScrollView.map { $0.image } as! [UIImage]
        delegate.product(images: images, tappedIn: index)
    }

    deinit {
        log.verbose("")
    }

    func configurePageControl() {
        // The total number of pages that are available is based on how many available images we have.
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
    }
    
    // MARK : - Clicking on pageControl
    @objc func changePage(sender: AnyObject) -> () {
        
        log.verbose("")
        let x = CGFloat(pageControl.currentPage) * self.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
}

extension ProductImageTableViewCell : UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        log.verbose("")

        let pageNumber = round(scrollView.contentOffset.x / self.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        log.verbose("")
//    }
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return scrollView.subviews[1]
//    }
    
}



