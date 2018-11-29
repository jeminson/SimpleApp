//
//  Utility.swift
//  BASIC
//
//  Created by Je Min Son on 2018. 11. 8..
//  Copyright © 2018년 Je Min Son. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    @IBInspectable var ViewCorner: CGFloat {    // @IB -> design component
        get {
            return layer.cornerRadius
            
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
            
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var viewBordercolor: UIColor {
        get {
            return UIColor(cgColor:layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func resizeimage(image:UIImage,withSize:CGSize) -> UIImage {
        var actualHeight:CGFloat = image.size.height
        var actualWidth:CGFloat = image.size.width
        let maxHeight:CGFloat = withSize.height
        let maxWidth:CGFloat = withSize.width
        var imgRatio:CGFloat = actualWidth/actualHeight
        let maxRatio:CGFloat = maxWidth/maxHeight
        let compressionQuality = 0.5
        if (actualHeight>maxHeight||actualWidth>maxWidth) {
            if (imgRatio<maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight/actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }else if(imgRatio>maxRatio){
                // adjust height according to maxWidth
                imgRatio = maxWidth/actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rec:CGRect = CGRect(x:0.0,y:0.0,width:actualWidth,height:actualHeight)
        UIGraphicsBeginImageContext(rec.size)
        image.draw(in: rec)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        let resizedimage = UIImage(data: imageData!)
        return resizedimage!
    }
}
