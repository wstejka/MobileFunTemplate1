//
//  UIselfExtension.swift
//  MobileFunTemplate1
//
//  Created by Wojciech Stejka on 10/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    func compressImage() -> UIImage? {
        
        var actualHeight : Float = Float(self.size.height)
        var actualWidth : Float = Float(self.size.width)
        let maxHeight : Float = 600.0
        let maxWidth : Float = 800.0
        var imgRatio : Float = actualWidth/actualHeight
        let maxRatio : Float = maxWidth/maxHeight
        let compressionQuality : CGFloat = 0.5 //50 percent compression
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if (imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
                else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect : CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))

        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        guard let image : UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        guard let imageData : Data = UIImageJPEGRepresentation(image, compressionQuality) else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)
    }
}
