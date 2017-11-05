//
//  ProductPageTableViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 04/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ProductPageTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: Vars/Consts
    private var urls : [URL?] = []
    
    var product : Product? {
        didSet {
            guard let product = product else { return }
            urls = product.urls.map({ (urlName) -> URL? in
                return URL(string: urlName)
            })
            log.verbose("")
        }
    }
    
    var tableCellFrameSize : CGSize? {
        
        didSet {
            log.verbose("")
            guard let size = tableCellFrameSize else { return }
            
            let pagesNumber = urls.count
            self.pageControl.numberOfPages = pagesNumber

            for index in 0..<pagesNumber {
                
                let inset : CGFloat = 10.0
                let widthWithInsets = size.width - (2 * inset)
                let factorRatio = size.height / size.width
                let subView = UIImageView(frame: CGRect(origin: CGPoint(x: size.width * CGFloat(index) + inset, y: 0.0),
                                                        size: CGSize(width: widthWithInsets, height: widthWithInsets * factorRatio)))
                subView.contentMode = .scaleAspectFit
                subView.sd_setImage(with: urls[index], completed: nil)
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

        // Do any additional setup after loading the view, typically from a nib.
        configurePageControl()

    }

    deinit {
        log.verbose("")
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
    }
    
    // MARK : - Clicking on pageControl
    @objc func changePage(sender: AnyObject) -> () {
        
        log.verbose("")
        let x = CGFloat(pageControl.currentPage) * (tableCellFrameSize?.width)!
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
}

extension ProductPageTableViewCell : UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        log.verbose("")

        let pageNumber = round(scrollView.contentOffset.x / (tableCellFrameSize?.width)!)
        self.pageControl.currentPage = Int(pageNumber)
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { [weak self] in
//        })
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let pageNumber = round(scrollView.contentOffset.x / (tableCellFrameSize?.width)!)
//        log.verbose("\(pageNumber)")
//    }
    
}



