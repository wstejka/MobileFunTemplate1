//
//  ProductPageTableViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 04/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

protocol ProductImageTapped {
    
    func product(images : [UIImage], tappedIn atIndex : Int)
    
}

class ProductPageTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: Vars/Consts
    private var urls : [URL?] = []
    var delegate : ProductImageTapped!
    
    var product : Product? {
        didSet {
            guard let product = product else { return }
            urls = product.urls.map({ (urlName) -> URL? in
                return URL(string: urlName)
            })
            log.verbose("")
        }
    }
    
    let cellTagShift = 100
    var cellFrameSize : CGSize? {
        
        didSet {
            log.verbose("")
            guard let size = cellFrameSize else { return }
            
            let pagesNumber = urls.count
            self.pageControl.numberOfPages = pagesNumber

            for index in 0..<pagesNumber {
                
                let inset : CGFloat = 0.0
                let widthWithInsets = size.width - (2 * inset)
                let factorRatio = size.height / size.width
                let subView = UIImageView(frame: CGRect(origin: CGPoint(x: size.width * CGFloat(index) + inset, y: 0.0),
                                                        size: CGSize(width: widthWithInsets, height: widthWithInsets * factorRatio)))
                subView.contentMode = .scaleAspectFit
                subView.sd_setImage(with: urls[index], completed: nil)
                subView.tag = index + cellTagShift
                scrollView.addSubview(subView)

            }
            scrollView.contentSize = CGSize(width: size.width * CGFloat(urls.count),
                                                 height: size.height)
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
//        let location = gesture.location(in: scrollView)
        // Get index of current UIImageView
        let index : Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
//        guard let tappedImage = scrollView.viewWithTag(Int(index) + cellTagShift) as? UIImageView else { return }
        
        delegate.product(images: getImages(), tappedIn: index)
    }

    deinit {
        log.verbose("")
    }

    func getImages() -> [UIImage] {
        
        let images = product?.urls.enumerated().map({ (arg) -> UIImage in
            
            let (index, _) = arg
            let imageView = scrollView.viewWithTag(index + cellTagShift) as? UIImageView
            return (imageView?.image!)!
        })
        
        return images!
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
        let x = CGFloat(pageControl.currentPage) * (cellFrameSize?.width)!
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
}

extension ProductPageTableViewCell : UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        log.verbose("")

        let pageNumber = round(scrollView.contentOffset.x / (cellFrameSize?.width)!)
        self.pageControl.currentPage = Int(pageNumber)
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        log.verbose("")
//    }
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return scrollView.subviews[1]
//    }
    
}



